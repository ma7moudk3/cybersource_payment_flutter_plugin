package com.cybersoruce_plugin.cybersoruce_plugin

import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.cybersoruce_plugin.cybersoruce_plugin.sessions.api.Environment
import com.cybersource.flex.android.CaptureContext.fromJwt
import com.cybersource.flex.android.FlexException
import com.cybersource.flex.android.FlexService
import com.cybersource.flex.android.TransientToken
import com.cybersource.flex.android.TransientTokenCreationCallback

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/** CybersorucePlugin */
class CybersorucePlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var cardNumber: String? = null
    private var month: String? = null
    private var year: String? = null
    private var cvv: String? = null
    private var keyId: String? = null
    private var merchantId: String? = null
    private var merchantKey: String? = null
    private var merchantSecret: String? = null
    private var environment: String? = null
    private var jsonObject: JSONObject? = null
    private var env: Environment? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "cybersoruce_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "tokenize") {
            Log.v("tokenize", "tokenize")
            cardNumber = call.argument("cardNumber")
            month = call.argument("month")
            year = call.argument("year")
            cvv = call.argument("cvv")
            merchantId = call.argument("merchantId")
            merchantKey = call.argument("merchantKey")
            merchantSecret = call.argument("merchantSecret")
            environment = call.argument("environment")
            env = if (environment.equals("production")) {
                Environment.PRODUCTION
            } else {
                Environment.SANDBOX
            }
            Log.v("cardNumber", cardNumber.toString())
            Log.v("month", month.toString())
            Log.v("year", year.toString())
            Log.v("cvv", cvv.toString())
            Log.v("merchantId", merchantId.toString())
            Log.v("merchantKey", merchantKey.toString())
            Log.v("merchantSecret", merchantSecret.toString())
            requestCaptureContext(result)
            // result.success(jsonObject)

        } else {
            result.notImplemented()
        }
    }

    private fun getPayloadData(): Map<String, Any>? {
        val sad: MutableMap<String, Any> = HashMap()

        if (cardNumber!!.isNotEmpty()) {
            sad["paymentInformation.card.number"] = cardNumber!!
        }
        if (cvv!!.isNotEmpty()) {
            sad["paymentInformation.card.securityCode"] = cvv!!
        }
        if (month!!.isNotEmpty()) {
            sad["paymentInformation.card.expirationMonth"] = month!!
        }
        if (year!!.isNotEmpty()) {
            sad["paymentInformation.card.expirationYear"] = year!!
        }

        return sad
    }

    private fun requestCaptureContext(
        result: Result,

        ) {

        /*  WARNING:
            Before creating TransientToken make sure you have a valid capture context.
            And below creation of capture context code is for demonstration purpose only.
        */
        CaptureContextHelper(
            merchantId!!,
            merchantKey!!,
            merchantSecret!!,
            env!!
        ).createCaptureContext(object : CaptureContextEvent {
            // override fun onCaptureContextError(e: Exception) {
            //     Log.e("onCaptureContextError", e.toString())
            //     result.error("onCaptureContextError", e.toString(), null)
            // }

            override fun onCaptureContextResponse(cc: String) {

                keyId = cc
                Log.v("CC", cc)
                val flexService = FlexService.getInstance()
                    try {
                        val payloadItems = getPayloadData()
                        val cc1 = fromJwt(keyId)
    
                        flexService.createTokenAsyncTask(cc1, payloadItems, object :
                            TransientTokenCreationCallback {
                            override fun onSuccess(tokenResponse: TransientToken?) {
                                if (tokenResponse != null) {
                                    Log.v("tt", "Token " + tokenResponse.toString())
                                    var json = JSONObject();
                                    json.put(
                                        "encodedToken",
                                        tokenResponse.encoded
                                    );
                                    json.put(
                                        "jti",
                                        tokenResponse.jwtClaims.getValue("jti")
                                    )
    
                                    //{iss=Flex/08, exp=1684067073, type=api-0.1.0, iat=1684066173, jti=1E38OI07NFK0TQC3JISMUB4IKCC030RJBS7ERP780RCQ74CCR85E6460D3016FC2, content={paymentInformation={card={expirationYear={value=2025}, number={maskedValue=XXXXXXXXXXXX1111, bin=411111}, securityCode={}, expirationMonth={value=12}}}}}
                                    json.put(
                                        "iss",
                                        tokenResponse.jwtClaims.getValue("iss")
                                    )
                                    json.put(
                                        "exp",
                                        tokenResponse.jwtClaims.getValue("exp")
                                    )
                                    json.put(
                                        "type",
                                        tokenResponse.jwtClaims.getValue("type")
                                    )
                                    json.put(
                                        "iat",
                                        tokenResponse.jwtClaims.getValue("iat")
                                    )
    
    
                                    jsonObject = json;
                                    Log.v("json", jsonObject.toString())
                                    result.success(jsonObject.toString())
    
                                }
                            }
    
                            override fun onFailure(error: FlexException?) {
                                Log.e("onFailure", error.toString())
                                result.error("Error", error.toString(), null)
                            }
                        })
                    } catch (e: FlexException) {
                        Log.v("tt", e.toString())
                        result.error("Error", e.toString(), null)
                    }
                print(cc)
            }
        })
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}