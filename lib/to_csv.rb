class Array
  def to_csv(options = {})
    return '' if self.empty?

    klass      = self.first.class
    attributes = self.first.attributes.keys.sort.map(&:to_sym)

    if options[:only]
      columns = Array(options[:only]) & attributes
    else
      columns = attributes - Array(options[:except])
    end

    columns += Array(options[:methods])

    return '' if columns.empty?

    output = FasterCSV.generate do |csv|
      csv << columns.map { |column| column.to_s.humanize } unless options[:headers] == false
      self.each do |item|
        csv << columns.collect do |column| 
          col = item.send(column)
          # sanitize the output, so that commas don't it off, maybe make this an option down the road?
          if col.nil?
            ''
          else
            col.is_a?(String) ? col.gsub(/[^a-z0-9]+/i, ' ') : col
          end
        end
      end
    end

    output
  end
end
