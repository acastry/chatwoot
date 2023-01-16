<template>
  <div class="dashboard-app--container">
      <iframe
        src="https://site-acceptance.siwo.com/atoomo/vendor/agenda"
      />
  </div>
</template>

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
