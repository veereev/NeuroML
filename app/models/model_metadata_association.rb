class ModelMetadataAssociation < ActiveRecord::Base
  attr_accessible :Comments, :Metadata_ID, :Model_ID
  self.primary_keys :Metadata_ID,:Model_ID
end
