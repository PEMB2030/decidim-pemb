# frozen_string_literal: true

require "csv"

# rubocop:disable Rails/Output
module ScriptHelpers
  HELP_TEXT = "
  usage: rails \"pemb:proposals:import[component_id,../some-file.csv]\"

  Not found proposals will be skipped"

  CSV_TEXT = "
  CSV format must follow this specification:

  1st line is treated as header and must containt the fields: id; state; text_ca; text_es; text_..; address
  Rest of the lines must containt values for the corresponding headers.

  Column separation is: ;
  "

  def process_csv(args)
    raise ArgumentError if args.component.blank?
    raise ArgumentError if args.csv.blank?

    component = Decidim::Component.find(args.component)
    raise AdminError, "Component #{args.component} not found!" unless component

    organization = component.organization
    raise AdminError, "Organization not found!" unless organization

    admin = Decidim::User.find_by(organization:, admin: true)
    raise AdminError, "First Admin not found!" unless admin

    table = CSV.parse(File.read(args.csv), headers: true, col_sep: ";")

    table.each_with_index do |line, index|
      print "##{index} (#{100 * (index + 1) / table.count}%): "
      begin
        yield(component:, admin:, line:)
      rescue UnprocessableError, ActiveRecord::RecordInvalid => e
        show_error(e.message)
      rescue AlreadyProcessedError => e
        show_warning(e.message)
      end
    end
  rescue ArgumentError => e
    puts
    show_error(e.message)
    show_help
  rescue CSV::MalformedCSVError => e
    puts
    show_error(e.message)
    show_csv_format
  rescue AdminError => e
    show_error(e.message)
  end

  def normalize(line)
    values = { title: {}, body: {} }
    line.each do |key, value|
      case key
      when /^ID$/i
        values[:id] = value
      when /^TITOL/i
        values[:title][:ca] = value
      when /^COS/i
        values[:body][:ca] = value
      when /^ADREÇA$/i
        values[:address] = value
      when /^CATEGORIA/i
        values[:category] = Decidim::Category.find_by(id: value)
      end
    end
    raise_if_field_not_found(:title, values)
    raise_if_field_not_found(:body, values)
    raise_if_field_not_found(:address, values)
    raise_if_field_not_found(:category, values)
    values
  end

  def geolocate(address)
    results = Geocoder.search(address)
    raise StandardError, "address not found" if results.blank?

    {
      latitude: results.first.latitude,
      longitude: results.first.longitude
    }
  rescue StandardError => e
    print " GEOLOCATE ERROR -#{e.message}- for [#{address}] "
  end

  def raise_if_field_not_found(field, values)
    raise UnprocessableError, "#{field.upcase} field not found for [#{values}]" if values[field].blank?
  end

  def show_error(msg)
    puts "\e[31mERROR:\e[0m #{msg}"
  end

  def show_warning(msg)
    puts "\e[33mWARN:\e[0m #{msg}"
  end

  def show_success(msg)
    puts " \e[32m#{msg}\e[0m"
  end

  def show_help
    puts HELP_TEXT
  end

  def show_csv_format
    puts CSV_TEXT
  end

  class AdminError < StandardError
  end

  class UnprocessableError < StandardError
  end

  class AlreadyProcessedError < StandardError
  end
end
# rubocop:enable Rails/Output
