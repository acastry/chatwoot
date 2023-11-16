<template>
  <div class="dashboard-app--container">
    <iframe :src="calendar_page" />
  </div>
</template>

<script>
import { required, minValue, maxValue } from 'vuelidate/lib/validators';
import { mapGetters } from 'vuex';
import alertMixin from 'shared/mixins/alertMixin';
import configMixin from 'shared/mixins/configMixin';
import accountMixin from '../../../../mixins/account';
const semver = require('semver');
export default {
  mixins: [accountMixin, alertMixin, configMixin],
  data() {
    return {
      id: '',
      name: '',
      locale: 'en',
      domain: '',
      supportEmail: '',
      features: {},
      autoResolveDuration: null,
      latestChatwootVersion: null,
      calendar_page: ''
    };
  },
  computed: {
    ...mapGetters({
      globalConfig: 'globalConfig/get',
      getAccount: 'accounts/getAccount',
      uiFlags: 'accounts/getUIFlags',
    }),
    getAccountId() {
      return this.id.toString();
    }
  },
  mounted() {
    this.initializeAccount();
  },
  methods: {
    async initializeAccount() {
      try {
        const {
          name,
          calendar_page,
          locale,
          id,
          domain,
          support_email,
          features,
          auto_resolve_duration,
          latest_chatwoot_version: latestChatwootVersion,
        } = this.getAccount(this.accountId);
        this.$root.$i18n.locale = locale;
        this.name = name;
        this.locale = locale;
        this.id = id;
        this.domain = domain;
        this.calendar_page = calendar_page;
        this.supportEmail = support_email;
        this.features = features;
        this.autoResolveDuration = auto_resolve_duration;
        this.latestChatwootVersion = latestChatwootVersion;
      } catch (error) {
        // Ignore error
      }
    }
  },
};
</script>

<style scoped>
.dashboard-app--container,
.dashboard-app--list,
.dashboard-app--list iframe,
.dashboard-app--container iframe {
  height: 100%;
  width: 100%;
}
.dashboard-app--list iframe {
  border: 0;
}
.dashboard-app_loading-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  width: 100%;
}
</style>