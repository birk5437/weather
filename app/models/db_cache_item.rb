class DbCacheItem < ActiveRecord::Base
  # NOTE: The db_cache_items table was created MANUALLY because Burke is lazy.  There is no migration.
  def self.get(key, options={})
    options.symbolize_keys!
    valid_for = options[:valid_for].presence || 1.month
    item = DbCacheItem.find_or_initialize_by_key(key)
    begin
      if item.new_record? || item.updated_at < DateTime.now - valid_for.seconds
        item.value = yield
        item.updated_at = DateTime.now
        item.save if item.value.present?
      end
    rescue
      nil
    end
    return item.value
  end
end
