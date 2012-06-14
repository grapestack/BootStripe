<cfparam name="details" default="services">

<cfif NOT isDefined("chargeAmount") or NOT isDefined("clientName") or NOT listFindNoCase("new,guest,none,private,pos", clientName)>

This is not a valid payment link.

<cfabort>

</cfif>

<cfif isDefined("application.stripePublic") and application.stripePublic is not 'STRIPE_PUBLISHABLE_KEY'>

	<cfset stripePublic = application.stripePublic>

<cfelse>

	<cfset stripePublic = "STRIPE_PUBLISHABLE_KEY">

</cfif>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Payment Form</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link href="assets/css/bootstrap.css" rel="stylesheet">
    <style>
      body {
        padding-top: 0px; /* 60px to make the container go all the way to the bottom of the topbar */
      }
    </style>
    <link href="assets/css/bootstrap-responsive.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="assets/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="assets/ico/apple-touch-icon-57-precomposed.png">    
    
    <script src="assets/js/jquery.js"></script><br>
    
  </head>

  <body>

    <div class="container">

      <h1>Payment Form</h1>

      <p>
      
        <form action="stripe.cfm" method="post" id="stripe-form" style="display: none;" class="form-horizontal">

        <fieldset>

          <div class="control-group">
            <label class="control-label" for="name">Amount</label>
            <div class="controls">
				<input type="text" value="<cfoutput>#dollarFormat(chargeAmount)#</cfoutput>" disabled />                
                <input type="hidden" name="chargeAmount" value="<cfoutput>#chargeAmount#</cfoutput>" />
              <p class="help-block"></p>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label" for="name">Description</label>
            <div class="controls">
				<textarea class="input-xlarge" id="textarea" rows="3" disabled><cfoutput>#details#</cfoutput></textarea>
                <input type="hidden" name="details" value="<cfoutput>#details#</cfoutput>" />
              <p class="help-block"></p>
            </div>
          </div>
        
          <div class="control-group">
            <label class="control-label" for="name">Name</label>
            <div class="controls">
              <input type="text" name="name" class="required" />
              <p class="help-block"></p>
            </div>
          </div>
         
          <div class="control-group">
            <label class="control-label" for="name">Email address</label>
            <div class="controls">
              <input type="text" name="email" class="required" />
              <p class="help-block"></p>
            </div>
          </div>
          
          <div class="control-group">
            <label class="control-label" for="card-number">Card number</label>
            <div class="controls">
              <input type="text" maxlength="20" autocomplete="off" class="card-number stripe-sensitive required" />
              <p class="help-block"></p>
            </div>
          </div>
          
          <div class="control-group">
            <label class="control-label" for="name">CVC</label>
            <div class="controls">
              <input type="text" maxlength="4" autocomplete="off" class="card-cvc stripe-sensitive required" />
              <p class="help-block"></p>
            </div>
          </div>
          
          <div class="control-group">
            <label class="control-label" for="name">Expiration</label>
            <div class="controls">
              <div class="expiry-wrapper">
                    <select class="card-expiry-month stripe-sensitive required">
                    </select>
                    <script type="text/javascript">
                        var select = $(".card-expiry-month"),
                            month = new Date().getMonth() + 1;
                        for (var i = 1; i <= 12; i++) {
                            select.append($("<option value='"+i+"' "+(month === i ? "selected" : "")+">"+i+"</option>"))
                        }
                    </script>
                    <span> / </span>
                    <select class="card-expiry-year stripe-sensitive required"></select>
                    <script type="text/javascript">
                        var select = $(".card-expiry-year"),
                            year = new Date().getFullYear();

                        for (var i = 0; i < 12; i++) {
                            select.append($("<option value='"+(i + year)+"' "+(i === 0 ? "selected" : "")+">"+(i + year)+"</option>"))
                        }
                    </script>
                </div>
              <p class="help-block"></p>
            </div>
          </div>                   
         
          <div class="form-actions">
            <button type="submit" class="btn btn-primary" name="submit-button">Submit</button>
            <span class="payment-errors"></span>
          </div>
        </fieldset>
        <input type="hidden" name="clientName" value="<cfoutput>#clientName#</cfoutput>" />
      </form>
      

        </form>


        <noscript><p>JavaScript is required for the registration form.</p></noscript>

      
      </p>

    </div> <!-- /container -->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="assets/js/jquery.validate.min.js"></script><br>
    <script src="assets/js/bootstrap.min.js"></script>

        <script type="text/javascript" src="https://js.stripe.com/v1/"></script>
        <script type="text/javascript">
          Stripe.setPublishableKey('<cfoutput>#stripePublic#</cfoutput>');
            $(document).ready(function() {
                function addInputNames() {
                    // Not ideal, but jQuery's validate plugin requires fields to have names
                    // so we add them at the last possible minute, in case any javascript 
                    // exceptions have caused other parts of the script to fail.
                    $(".card-number").attr("name", "card-number")
                    $(".card-cvc").attr("name", "card-cvc")
                    $(".card-expiry-year").attr("name", "card-expiry-year")
                }

                function removeInputNames() {
                    $(".card-number").removeAttr("name")
                    $(".card-cvc").removeAttr("name")
                    $(".card-expiry-year").removeAttr("name")
                }

                function submit(form) {
                    // remove the input field names for security
                    // we do this *before* anything else which might throw an exception
                    removeInputNames(); // THIS IS IMPORTANT!

                    // given a valid form, submit the payment details to stripe
                    $(form['submit-button']).attr("disabled", "disabled")

                    Stripe.createToken({
                        number: $('.card-number').val(),
                        cvc: $('.card-cvc').val(),
                        exp_month: $('.card-expiry-month').val(), 
                        exp_year: $('.card-expiry-year').val()
                    }, 100, function(status, response) {
                        if (response.error) {
                            // re-enable the submit button
                            $(form['submit-button']).removeAttr("disabled")
        
                            // show the error
                            $(".payment-errors").html(response.error.message);

                            // we add these names back in so we can revalidate properly
                            addInputNames();
                        } else {
                            // token contains id, last4, and card type
                            var token = response['id'];

                            // insert the stripe token
                            var input = $("<input name='stripeToken' value='" + token + "' style='display:none;' />");
                            form.appendChild(input[0])

                            // and submit
                            form.submit();
                        }
                    });
                    
                    return false;
                }
                
                // add custom rules for credit card validating
                jQuery.validator.addMethod("cardNumber", Stripe.validateCardNumber, "Please enter a valid card number");
                jQuery.validator.addMethod("cardCVC", Stripe.validateCVC, "Please enter a valid security code");
                jQuery.validator.addMethod("cardExpiry", function() {
                    return Stripe.validateExpiry($(".card-expiry-month").val(), 
                                                 $(".card-expiry-year").val())
                }, "Please enter a valid expiration");

                // We use the jQuery validate plugin to validate required params on submit
                $("#stripe-form").validate({
                    submitHandler: submit,
                    rules: {
                        "card-cvc" : {
                            cardCVC: true,
                            required: true
                        },
                        "card-number" : {
                            cardNumber: true,
                            required: true
                        },
                        "card-expiry-year" : "cardExpiry" // we don't validate month separately
                    }
                });

                // adding the input field names is the last step, in case an earlier step errors                
                addInputNames();
            });
        </script>
        
        <!-- 
            The easiest way to indicate that the form requires JavaScript is to show
            the form with JavaScript (otherwise it will not render). You can add a
            helpful message in a noscript to indicate that users should enable JS.
        -->
        <script>if (window.Stripe) $("#stripe-form").show()</script>

  </body>
</html>