module TeacherTypes

  def complete_teacher
    DatabaseCleaner.strategy = :truncation

    # # then, whenever you need to clean the DB
    DatabaseCleaner.clean
    @category = FactoryGirl.create(:category)
    
    @price = FactoryGirl.create(:price)
    @qualification = FactoryGirl.create(:qualification)
    # @subject = FactoryGirl.create(:subject)

    @subject = FactoryGirl.create(:subject)
    @category.subjects << @subject
    @experience = FactoryGirl.create(:experience)
    @location = FactoryGirl.create(:location)
    @photo = FactoryGirl.create(:photo)    

    @teacher = FactoryGirl.create(:teacher, :admin, :complete)
    @teacher.qualifications << @qualification
    @teacher.photos << @photo
    @teacher.prices << @price
    @teacher.subjects << @subject
    @teacher.experiences << @experience
    @teacher.locations << @location
    @teacher

  end
end