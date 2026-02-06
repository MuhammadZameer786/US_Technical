# config/initializers/paper_trail_ransack.rb

# 1. Force load the PaperTrail library structure
require "paper_trail/frameworks/active_record"

Rails.application.config.to_prepare do
  # 2. Check if the class exists to avoid crashing if the gem is removed later
  if defined?(PaperTrail::Version)
    PaperTrail::Version.class_eval do
      def self.ransackable_attributes(auth_object = nil)
        column_names
      end

      def self.ransackable_associations(auth_object = nil)
        reflect_on_all_associations.map { |a| a.name.to_s }
      end
    end
  end
end
