BootStripe
==========

Bootstrap + Stripe + Stripe.cfc = Pretty Easy Payments

To use this form you only need to replace the secret and publishable Stripe keys in Application.cfc (or place them on the form.cfm and stripe.cfm pages if you do not use the Application.cfc)

To use the form, just upload the files to your web server and access the URL as in the example below:

https://www.grapestack.com/invoice/form.cfm?chargeAmount=1.00&clientName=new&details=consulting%20services

The clientName parameter is a very simple list-based protection you can use to help prevent unauthorized access to your payment form. The list needs to be changed at the top of both form.cfm and stripe.cfm if you decide to use it, otherwise just provide clientName=new (new is one of the default values in the list)

Upon pressing "Submit" the credit card details are sent via AJAX directly to Stripe's servers over SSL, bypassing your server completely, and a token is returned to the browser and added to the form as a hidden field. Once the token has been returned by Stripe the form is then submitted as normal to stripe.cfm. The stripe.cfm page then contacts Stripe's servers and sends the token along with the amount to charge. Stripe uses the token to identify the correct credit card details on their servers and then attempts to charge the specified amount.

The user never leaves your website to make the payment, so your payment page is on your own domain and can be completely custom.

The credit card details never interact with your server and are only sent to Stripe over a secure connection in exchange for a single-use token, so you don't have to worry about PCI compliance because you are never receiving the actual credit card details. You only receive a token that your processing page sends to Stripe, along with the amount you wish to charge, and Stripe returns the result.

For added security, it is recommended that you still place your payment form on a secure (HTTPS) page using SSL, but it is not absolutely necessary, only recommended.

https://stripe.com/

Stripe is a full-stack payment solution that lets you start accepting payments in minutes without the usual hassles.