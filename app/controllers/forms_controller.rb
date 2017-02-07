class FormsController < ApplicationController
  def adopt
    @adopt = StaticPage.first.adopt
    logger.info "*************************"
    logger.info "ADOPT*************************"
    logger.info params.inspect
    logger.info "*************************"
    logger.info "*************************"
  end

  def contact
    @errors = {}
    @form = {}
#first name
    if /\A\w+\Z/.match(params["first_name"]) && params["first_name"].length < 15
        @form["First Name"] = params["first_name"]
    else
        @errors["First Name"] = "cannot be blank, have numbers, and must be under 15 characters long."
    end
#last name
    if /\A\w+\Z/.match(params["last_name"]) && params["last_name"].length < 15
        @form["Last Name"] = params["last_name"]
    else
        @errors["Last Name"] = "cannot be blank, have numbers, and must be under 15 characters long."
    end

    if /\A\(?\d{3}\)?\-?\d{3}\-?\d{4}\Z/.match(params["phone_number"]) 
        @form["Phone Number"] = params["phone_number"]
    else
        @errors["Phone Number"] = "invalid format. Please use XXX-YYY-ZZZZ, (XXX)-YYYZZZZ, (XXX)-YYY-ZZZZ, or XXXYYYZZZZ."
    end

    if /\A\w+\@\w+\.\w+\Z/.match(params["email"])
        @form["Email"] = params["email"]
    else
        @errors["Email"] = "cannot be blank and must follow email@emaildomain.domain format. Example: email@gmail.com"
    end

    if params["message"].length > 0 && params["message"].length < 400
        @form["Message"] = params["message"]
    else
        @errors["Message"] = "cannot be blank and cannot have length longer than 400 characters."
    end
    respond_to do |format|
        if @errors.any?
            format.html { render "static_pages/contact_us" } 
            format.json { render json: @errors, status: :unprocessable_entity }
        else
            UserMailer.contact_email(@form).deliver
            flash[:success] = "Your form was submitted successfully. An administrator will contact you soon."
            format.html { redirect_to "/contact_us" }
        end
    end
  end

  def send_adoption
    @user = {}
    @errors = {}
#validations
#dog name
    if /\A\w+\Z/.match(params["dog_name"]) && params["dog_name"].length < 15
        @user["Name of dog or puppy you're interested in adopting"] = params["dog_name"].capitalize
    else
        @errors["Dog Name"] = "cannot be blank, have numbers, and must be under 15 characters long."

    end
#first name
    if /\A\w+\Z/.match(params["first_name"]) && params["first_name"].length < 15
        @user["Your first name"] = params["first_name"].capitalize
    else
        @errors["First Name"] = "cannot be blank, have numbers, and must be under 15 characters long."
    end
#last name
    if /\A\w+\Z/.match(params["last_name"]) && params["last_name"].length < 15
        @user["Your last name"] = params["last_name"].capitalize
    else
        @errors["Last Name"] = "cannot be blank, have numbers, and must be under 15 characters long."
    end
#age
    if /\A\d+\Z/.match(params["age"]) && params["age"].to_i > 0 && params["age"].to_i < 122 
        @user["Your Age"] = params["age"]
    else
        @errors["Age"] = "cannot be blank and be a number greater than 0 and less than 122."
    end
#address
    if params["street_address"] && params["street_address"].length < 150
        @user["Street Address"] = params["street_address"]
    else 
        @errors["Street Address"] = "cannot be blank and cannot have length longer than 150 characters."
    end
#address line 2, can be blank but cannot be longer than 150 chars
    if params["street_address_line_two"] && params["street_address_line_two"].length > 150
        @errors["Street Address Line Two"] = "cannot have length longer than 150 characters."
    elsif !params["street_address_line_two"].blank?
        @user["Street Address Line Two"] = params["street_address"]
    end
#city
    if /\A\w+\Z/.match(params["city"]) && params["city"].length < 50
        @user["City"] = params["city"].capitalize
    else
        @errors["City"] = "cannot be blank, and cannot have length longer than 50 characters."
    end
#state
    if /\A\w+\Z/.match(params["state"]) && params["state"].length < 20
        @user["State"] = params["state"].capitalize
    else
        @errors["State"] = "cannot be blank, and cannot have length longer than 20 characters."
    end
#zip
    if /\A\d{5}(-\d{4})?\Z/.match(params["zip"]) 
        @user["ZIP Code"] = params["zip"]
    else
        @errors["ZIP"] = "invalid format. Please use 12345-1234 or 12345."
    end
#phone
    if /\A\(?\d{3}\)?\-?\d{3}\-?\d{4}\Z/.match(params["preferred_phone_number"]) 
        @user["Preferred Phone Number"] = params["preferred_phone_number"]
    else
        @errors["Preferred Phone Number"] = "invalid format. Please use XXX-YYY-ZZZZ, (XXX)-YYYZZZZ, (XXX)-YYY-ZZZZ, or XXXYYYZZZZ."
    end
#secondary phone, can be blank
    if !params["secondary_phone_number"].blank? 
        if /\A\(?\d{3}\)?\-?\d{3}\-?\d{4}\Z/.match(params["secondary_phone_number"]) 
            @user["Secondary Phone Number"] = params["secondary_phone_number"]
        else
            @errors["Secondary Phone Number"] = "invalid format. Please use XXX-YYY-ZZZZ, (XXX)-YYYZZZZ, (XXX)-YYY-ZZZZ, or XXXYYYZZZZ."
        end
    end
#email
    if /\A\w+\@\w+\.\w+\Z/.match(params["email"])
        @user["Email"] = params["email"].downcase
    else
        @errors["Email"] = "cannot be blank and must follow email@emaildomain.domain format. Example: email@gmail.com"
    end
#other pets
    if params["pets"].length > 0 && params["pets"].length < 300
        @user["What other pets do you have?"] = params["pets"]
    else
        @errors["Other pets you have"] = "cannot be blank and cannot have length longer than 300 characters."
    end
#pets
    if params["household_pets"].length > 0 && params["household_pets"].length < 300
        @user["What other people live in your household?"] = params["household_pets"]
    else
        @errors["Other people which live in your household"] = "cannot be blank and cannot have length longer than 300 characters."
    end
#apt or house
    if params["building"]
        if params["building"] == "house" || params["building"] == "apartment"
            @user["Do you live in an apartment or house?"] = params["building"].capitalize
        else
            @errors["Live in an apartment or house"] = "invalid choice between house and apartment."
        end
    else
        @errors["Live in an apartment or house"] = "you must select between house or apartment."
    end
#own or rent
#landlord name & phone number
    if params["payment"]
        if params["payment"] == "own" || params["payment"] == "rent"
            @user["Do you own or rent?"] = params["payment"].capitalize
            if params["payment"] == "rent"
                if params["landlord_name"].length > 0 && params["landlord_name"].length < 50
                    @user["If you rent, provide your landord's name"] = params["landlord_name"]
                else
                    @errors["Landlord name"] = "cannot be blank and cannot have length longer than 50 characters."
                end
                if /\A\(?\d{3}\)?\-?\d{3}\-?\d{4}\Z/.match(params["landlord_phone"])
                    @user["If you rent, provide your landlord's phone number"] = params["landlord_phone"]
                else
                    @errors["Landlord Phone Number"] = "invalid format. Please use XXX-YYY-ZZZZ, (XXX)-YYYZZZZ, (XXX)-YYY-ZZZZ, or XXXYYYZZZZ."
                end
            end
        else
            @errors["Own or rent"] = "invalid choice between own and rent."
        end
    else
        @errors["Own or rent"] = "you must select own or rent."
    end
#pet sleep
    if params["pet_sleep"].length > 0 && params["pet_sleep"].length < 300
        @user["Describe where this pet will be kept during the day and at night"] = params["pet_sleep"]
    else
        @errors["Where pet will be kept during day or night."] = "cannot be blank and cannot have length less than 300 characters."
    end
#unattended
    if params["unattended"].to_i.between?(0, 24)
        @user["During a normal day, how many hours will this pet be unattended(left alone)?"] = params["unattended"]
    else
        @errors["How many hours pet will be unattended"] = "cannot be blank and must be a number between 0 and 24."
    end
#fenced yard
    if params["fenced"] 
        if params["fenced"] == "yes" || params["fenced"] == "no"
            @user["Do you have a fenced yard?"] = params["fenced"].capitalize
        else
            @errors["Do you have a fenced yard?"] = "invalid option."
        end
    else
        @errors["Do you have a fenced yard?"] = "you must select between Yes and No."
    end
#afford a pet
    if params["afford"] 
        if params["afford"] == "yes" || params["afford"] == "no"
            @user["Can you afford a pet?"] = params["afford"].capitalize
        else
            @errors["Can you afford a pet?"] = "invalid option."
        end
    else
        @errors["Can you afford a pet?"] = "you must select between Yes and No."
    end
#pet traits
    if params["pet_traits"].length > 0 && params["pet_traits"].length < 500
        @user["What behavior traits would absolutely NOT be acceptable to you and would cause you to return a pet?"] = params["pet_traits"]
    else
        @errors["What behavior traits would absolutely NOT be acceptable to you and would cause you to return apet?"] = "cannot be blank and cannot have length longer than 500 characters."
    end
#living with ppl with alergies
    if params["allergies"]
        if params["allergies"] == "yes" || params["allergies"] == "no"
            @user["Do you or others living with you have allergies?"] = params["allergies"].capitalize
        else
            @errors["Do you or other living with you have allergies?"] = "invalid option."
        end
    else
        @errors["Do you or other living with you have allergies?"] = "you must select between Yes and No."
    end
#reference
    if params["reference"].length > 0 && params["reference"].length < 50
        @user["Provide the name of a veterinary reference"] = params["reference"]
    else
        @errors["Veterinary reference"] = "cannot be blank and cannot have length more than 50 charcters"
    end
#reference addr
    if params["reference_addr"].length > 0 && params["reference_addr"].length < 100
        @user["Provide the address of your veterinary reference"] = params["reference_addr"]
    else
        @errors["Veterinary reference address"] = "cannot be blank and cannot have length more than 100 charcters."
    end
#reference phone number
     if /\A\(?\d{3}\)?\-?\d{3}\-?\d{4}\Z/.match(params["reference_phone"])
        @user["Provide the phone number for your veterinary reference"] = params["reference_phone"]
    else
        @errors["Veterinary reference Phone Number"] = "invalid format. Please use XXX-YYY-ZZZZ, (XXX)-YYYZZZZ, (XXX)-YYY-ZZZZ, or XXXYYYZZZZ."
    end   
#reference pet list
    if params["reference_pet"].length > 0 && params["reference_pet"].length < 200
        @user["List the name(s) of the pet(s) cared for at this vet's office"] = params["reference_pet"]
    else
        @errors["Veterinary pet list"] = "cannot be blank and cannot have length more than 200 charcters."
    end
#personal reference name 
    if /\A\w+\Z/.match(params["personal_ref_name"]) && params["personal_ref_name"].length < 50
        @user["Provide the name of a personal reference"] = params["personal_ref_name"]
    else
        @errors["Personal reference name"] = "cannot be blank and cannot have length longer than 50 characters."
    end
#personal reference phone number
     if /\A\(?\d{3}\)?\-?\d{3}\-?\d{4}\Z/.match(params["personal_ref_phone"])
        @user["Provide a phone number for your personal reference"] = params["personal_ref_phone"]
    else
        @errors["Personal reference Phone Number"] = "invalid format. Please use XXX-YYY-ZZZZ, (XXX)-YYYZZZZ, (XXX)-YYY-ZZZZ, or XXXYYYZZZZ."
    end
#criteria in adopted pet
    if params["criteria"].length > 0 && params["criteria"].length < 400
        @user["What criteria are you looking for in your adopted pet?"] = params["criteria"]
    else
        @errors["Criteria in adopted pet"] = "cannot be blank and cannot have length longer than 400 characters."
    end
#experience 
    if params["experience"].length > 0 && params["experience"].length < 400
        @user["Tell us a little bit about your past experience with dogs/puppies"] = params["experience"]
    else
        @errors["Experience with pets"] = "cannot be blank and cannot have length longer than 400 characters."
    end


    respond_to do |format|
        if @errors.any?
            format.html { render "adopt" } 
            format.json { render json: @errors, status: :unprocessable_entity }
        else
            UserMailer.adopt_email(@user).deliver
            flash[:success] = "Your form was submitted successfully. An email with information about your adoption status should be sent to you shortly."
            format.html { redirect_to "/adopt" }
        end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_params
      params.fetch(:form, {})
    end
end
