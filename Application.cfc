<cfcomponent>

<cfset THIS.ApplicationName = "stripePayments" />
<cfset THIS.SessionManagement = true />
<cfset THIS.SessionTimeout = CreateTimeSpan( 0, 0, 1, 0 ) />

<cfset THIS.Application.stripePublic = "STRIPE_PUBLISHABLE_KEY">
<cfset THIS.Application.stripePrivate = "STRIPE_SECRET_KEY">

<cfsetting showdebugoutput="false" enablecfoutputonly="false" />

<cffunction name="onRequestStart">
</cffunction>

</cfcomponent>