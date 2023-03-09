class DashboardController < ActionController::Base
  include SwitchLocale

  before_action :set_global_config
  around_action :switch_locale
  before_action :ensure_installation_onboarding, only: [:index]
  before_action :render_hc_if_custom_domain, only: [:index]
  before_action :set_current_user, unless: :devise_controller?

  layout 'vueapp'

  def index; 
    # if !@user
    #   return
    # end
    if @user
      account_user = AccountUser.find_by(user_id: @user.id) 
      to_path = '/app/accounts/'+account_user.account_id.to_s+'/reports/overview'       
      if account_user.role == "client" && request.path != to_path
        redirect_to to_path
      end
    end
  end

  private

  def set_current_user
    @user ||= current_user
    Current.user = @user
  end

  def set_global_config
    @global_config = GlobalConfig.get(
      'LOGO', 'LOGO_THUMBNAIL',
      'INSTALLATION_NAME',
      'WIDGET_BRAND_URL', 'TERMS_URL',
      'PRIVACY_URL',
      'DISPLAY_MANIFEST',
      'CREATE_NEW_ACCOUNT_FROM_DASHBOARD',
      'CHATWOOT_INBOX_TOKEN',
      'API_CHANNEL_NAME',
      'API_CHANNEL_THUMBNAIL',
      'ANALYTICS_TOKEN',
      'DIRECT_UPLOADS_ENABLED',
      'HCAPTCHA_SITE_KEY',
      'LOGOUT_REDIRECT_LINK',
      'DISABLE_USER_PROFILE_UPDATE',
      'DEPLOYMENT_ENV',
      'CSML_EDITOR_HOST'
    ).merge(app_config)

    if request.parameters["params"] and request.parameters["params"].match(/^accounts\/(\d+)(?:\/(.+))?$/)
      account_number = $1.to_i
      # account_number = 38439
      account = Account.find_by(id: account_number)
      # p account
      # puts "pppppppppppp"
      if account
        @global_config["INSTALLATION_NAME"] = account.name + " - " + @global_config["INSTALLATION_NAME"]
      end
    end
  end

  def ensure_installation_onboarding
    redirect_to '/installation/onboarding' if ::Redis::Alfred.get(::Redis::Alfred::CHATWOOT_INSTALLATION_ONBOARDING)
  end

  def render_hc_if_custom_domain
    domain = request.host
    return if domain == URI.parse(ENV.fetch('FRONTEND_URL', '')).host

    @portal = Portal.find_by(custom_domain: domain)
    return unless @portal

    @locale = @portal.default_locale
    render 'public/api/v1/portals/show', layout: 'portal', portal: @portal and return
  end

  def app_config
    {
      APP_VERSION: Chatwoot.config[:version],
      VAPID_PUBLIC_KEY: VapidService.public_key,
      ENABLE_ACCOUNT_SIGNUP: GlobalConfigService.load('ENABLE_ACCOUNT_SIGNUP', 'false'),
      FB_APP_ID: GlobalConfigService.load('FB_APP_ID', ''),
      FACEBOOK_API_VERSION: 'v14.0',
      IS_ENTERPRISE: ChatwootApp.enterprise?,
      AZURE_APP_ID: ENV.fetch('AZURE_APP_ID', '')
    }
  end
end
