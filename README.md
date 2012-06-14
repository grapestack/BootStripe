BootStripe
==========

Bootstrap + Stripe + Stripe.cfc = Pretty Easy Payments

To use this form you only need to replace the secret and publishable Stripe keys in Application.cfc (or place them on the form.cfm and stripe.cfm pages if you do not use the Application.cfc)

To use the form, just upload the files to your web server and access the URL as in the example below:

https://www.grapestack.com/invoice/form.cfm?chargeAmount=1.00&details=consulting%20services&clientName=new

The clientName parameter is a very simple list-based protection you can use to help prevent unauthorized access to your payment form. The list needs to be changed at the top of both form.cfm and stripe.cfm if you decide to use it, otherwise just provide clientName=new (new is one of the default values in the list)

https://stripe.com/
Stripe is a full-stack payment solution that lets you start accepting payments in minutes without the usual hassles.