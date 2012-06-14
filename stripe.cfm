<cfif NOT isDefined("chargeAmount") or NOT isDefined("clientName") or NOT listFindNoCase("new,guest,none,private,pos", clientName)>

This is not a valid payment link.

<cfabort>

</cfif>

<cfif isDefined("application.stripePrivate") and application.stripePrivate is not 'STRIPE_SECRET_KEY'>

	<cfset stripePrivate = application.stripePrivate>

<cfelse>

	<cfset stripePrivate = "STRIPE_PRIVATE_KEY">

</cfif>

<cfscript>

stripeApiKey = '#stripePrivate#';
Stripe = createObject('component','Stripe').init(stripeApiKey=stripeApiKey);

StripeResult = Stripe.createCharge(amount=#chargeAmount#,card=form.stripeToken,description='#now()# - #details#');

</cfscript>

<cfif #StripeResult.paid# is true>

	<cfoutput>
    
    Thank you for your payment!
    
    <hr  />
    
    #dollarFormat(chargeAmount)#
    
    <br />
    
    #details#
    
    <hr />
    
    <cfif isDefined("email") and email is not ''>
    
        <cfmail to="#email#" from="you@domain.com" subject="Successful payment" server="domain.com">
        Thank you for your payment!
        <br />
        <br />
        #dollarFormat(chargeAmount)#
        <br />
        #details#
        </cfmail>
        
        A receipt has been emailed to <cfoutput>#email#</cfoutput>
    
    </cfif>

	</cfoutput>

<cfelse>

	Your payment did not go through, please press the back button and try again.
    
</cfif>