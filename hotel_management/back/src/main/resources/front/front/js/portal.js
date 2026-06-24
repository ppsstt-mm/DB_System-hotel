(function (window) {
  const CONTEXT_PATH = '/springbootb1g8z';
  const ORIGIN = window.location.origin;
  const API_BASE = `${ORIGIN}${CONTEXT_PATH}/`;
  const FRONT_BASE = `${API_BASE}front/`;
  const ADMIN_URL = 'http://localhost:8081/#/login';
  const APP_VERSION = '20260521b';

  function normalizePath(path) {
    return String(path || '').replace(/^\//, '');
  }

  function query(name) {
    return new URLSearchParams(window.location.search).get(name);
  }

  function pageUrl(path) {
    const clean = `${FRONT_BASE}${normalizePath(path)}`;
    return clean + (clean.includes('?') ? `&v=${APP_VERSION}` : `?v=${APP_VERSION}`);
  }

  function escapeHtml(value) {
    return String(value == null ? '' : value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function stripHtml(value) {
    return String(value || '')
      .replace(/<[^>]+>/g, ' ')
      .replace(/\s+/g, ' ')
      .trim();
  }

  function assetUrl(path) {
    if (!path) {
      return 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="720"><rect width="100%" height="100%" fill="%23edf2f7"/><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" fill="%235f6b7a" font-size="30">Hotel Image</text></svg>';
    }
    const clean = String(path).split(',')[0].trim();
    if (/^https?:\/\//i.test(clean)) {
      return clean;
    }
    return `${API_BASE}${clean.replace(/^\//, '')}`;
  }

  function formatMoney(value) {
    const num = Number(value || 0);
    return `¥ ${num.toFixed(2)}`;
  }

  function formatDate(value) {
    if (!value) {
      return '-';
    }
    const text = String(value).replace('T', ' ');
    return text.length >= 10 ? text.slice(0, 10) : text;
  }

  function formatDateTime(value) {
    if (!value) {
      return '-';
    }
    const text = String(value).replace('T', ' ');
    return text.length >= 19 ? text.slice(0, 19) : text;
  }

  function bookingStatusLabel(value) {
    return {
      created: '预订中',
      checked_in: '已入住',
      completed: '已完成',
      cancelled: '已取消'
    }[value] || (value || '未登记');
  }

  function orderTrackingLabel(row) {
    if (!row) {
      return '未登记';
    }
    if (row.booking_status === 'created') {
      if (row.ispay === 'paid' || row.ispay === 'partial') {
        return '待入住';
      }
      if (row.ispay === 'refunded') {
        return '已退款';
      }
      return '待支付';
    }
    return bookingStatusLabel(row.booking_status);
  }

  function payStatusLabel(value) {
    return {
      unpaid: '未支付',
      partial: '部分支付',
      paid: '已支付',
      refunded: '已退款'
    }[value] || (value || '未支付');
  }

  function roomStatusLabel(value) {
    return {
      available: '可预订',
      reserved: '已预订',
      occupied: '入住中',
      cleaning: '清扫中',
      maintenance: '维修中'
    }[value] || (value || '未登记');
  }

  function getToken() {
    return localStorage.getItem('Token') || '';
  }

  function isLoggedIn() {
    return localStorage.getItem('userTable') === 'customer' && !!getToken();
  }

  function rememberSelectedRoomId(roomId) {
    if (roomId !== undefined && roomId !== null && String(roomId).trim() !== '') {
      sessionStorage.setItem('portalSelectedRoomId', String(roomId));
    }
  }

  function getSelectedRoomId() {
    return sessionStorage.getItem('portalSelectedRoomId') || '';
  }

  function clearSelectedRoomId() {
    sessionStorage.removeItem('portalSelectedRoomId');
  }

  function clearAuth() {
    ['Token', 'role', 'userTable', 'sessionTable', 'adminName', 'userid', 'vip'].forEach(function (key) {
      localStorage.removeItem(key);
    });
  }

  async function api(path, options = {}) {
    const method = options.method || 'GET';
    const headers = Object.assign({}, options.headers || {});
    const token = getToken();
    if (token) {
      headers.Token = token;
    }

    let url = `${API_BASE}${normalizePath(path)}`;
    const fetchOptions = { method, headers };

    if (method === 'GET' && options.params) {
      const params = new URLSearchParams();
      Object.keys(options.params).forEach(function (key) {
        const value = options.params[key];
        if (value !== undefined && value !== null && value !== '') {
          params.append(key, value);
        }
      });
      const queryString = params.toString();
      if (queryString) {
        url += (url.includes('?') ? '&' : '?') + queryString;
      }
    } else if (options.json) {
      headers['Content-Type'] = 'application/json';
      fetchOptions.body = JSON.stringify(options.json);
    } else if (options.form) {
      headers['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8';
      fetchOptions.body = new URLSearchParams(options.form).toString();
    }

    const response = await fetch(url, fetchOptions);
    const data = await response.json();
    if (data.code === 401 || data.code === 403) {
      clearAuth();
      if (!window.location.pathname.endsWith('/pages/login/login.html')) {
        window.location.href = pageUrl(`pages/login/login.html?redirect=${encodeURIComponent(window.location.pathname.replace(`${CONTEXT_PATH}/front/`, ''))}`);
      }
      throw new Error(data.msg || '请先登录');
    }
    if (data.code !== 0) {
      throw new Error(data.msg || '请求失败');
    }
    return data;
  }

  function toast(message, type) {
    const node = document.createElement('div');
    node.className = `portal-toast${type ? ` ${type}` : ''}`;
    node.textContent = message;
    document.body.appendChild(node);
    window.setTimeout(function () {
      node.remove();
    }, 2400);
  }

  function emptyState(message, actionHtml) {
    return `
      <div class="portal-empty">
        <strong>${escapeHtml(message || '暂无数据')}</strong>
        ${actionHtml || ''}
      </div>
    `;
  }

  function ensureLogin(redirectPath) {
    if (!isLoggedIn()) {
      const target = redirectPath || window.location.pathname.replace(`${CONTEXT_PATH}/front/`, '');
      window.location.href = pageUrl(`pages/login/login.html?redirect=${encodeURIComponent(target)}`);
      return false;
    }
    return true;
  }

  function favoriteTargetHref(tableName, refId) {
    if (tableName === 'room_catalog') {
      return pageUrl(`pages/room_catalog/detail.html?id=${refId}`);
    }
    if (tableName === 'hotel_profile') {
      return pageUrl('pages/hotel_profile/list.html');
    }
    return pageUrl('index.html');
  }

  async function currentCustomer() {
    if (!isLoggedIn()) {
      return null;
    }
    const result = await api('customer/session', { method: 'GET' });
    return result.data || null;
  }

  function initials(name) {
    const text = String(name || '').trim();
    if (!text) {
      return '住客';
    }
    return text.length === 1 ? text : text.slice(0, 2);
  }

  function avatarColor(seed) {
    const palette = ['#0f766e', '#2563eb', '#7c3aed', '#b45309', '#be123c', '#334155'];
    let sum = 0;
    String(seed || '').split('').forEach(function (char) {
      sum += char.charCodeAt(0);
    });
    return palette[sum % palette.length];
  }

  function avatarMarkup(name) {
    return `<span class="portal-avatar" style="background:${avatarColor(name)}">${escapeHtml(initials(name))}</span>`;
  }

  function scoreStars(score) {
    const count = Math.max(1, Math.min(5, Number(score || 5)));
    return '★'.repeat(count) + '☆'.repeat(5 - count);
  }

  function navMarkup(current, subtitle) {
    const nav = [
      { key: 'home', label: '首页', href: pageUrl('index.html') },
      { key: 'rooms', label: '客房浏览', href: pageUrl('pages/room_catalog/list.html') },
      { key: 'hotel', label: '酒店信息', href: pageUrl('pages/hotel_profile/list.html') },
      { key: 'notice', label: '酒店公告', href: pageUrl('pages/notice/list.html') },
      { key: 'orders', label: '我的订单', href: pageUrl('pages/booking_order/list.html') }
    ];
    if (isLoggedIn()) {
      nav.push({ key: 'favorite', label: '我的收藏', href: pageUrl('pages/favorite/list.html') });
      nav.push({ key: 'center', label: '个人中心', href: pageUrl('pages/customer/center.html') });
    }

    return `
      <div class="portal-topbar">
        <div class="portal-container portal-nav">
          <div class="portal-brand">
            <strong>酒店管理系统</strong>
            <span>${escapeHtml(subtitle || '在线客房浏览与预订')}</span>
          </div>
          <div class="portal-nav-links">
            ${nav.map(function (item) {
              const active = item.key === current ? ' style="background:#eef3f8;color:#0f766e;"' : '';
              return `<a class="portal-nav-link" href="${item.href}"${active}>${item.label}</a>`;
            }).join('')}
          </div>
          <div class="portal-nav-actions" id="portalAuthActions"></div>
        </div>
      </div>
    `;
  }

  function mountTopbar(options = {}) {
    const host = document.querySelector('[data-portal-header]');
    if (!host) {
      return;
    }
    host.innerHTML = navMarkup(options.current || '', options.subtitle || '');
    const actions = host.querySelector('#portalAuthActions');
    if (!actions) {
      return;
    }

    if (isLoggedIn()) {
      const name = localStorage.getItem('adminName') || '当前用户';
      actions.innerHTML = `
        <span class="portal-muted">您好，${escapeHtml(name)}</span>
        <a class="portal-button-secondary" href="${pageUrl('pages/customer/center.html')}">个人中心</a>
        <button class="portal-button-danger" type="button" id="portalLogoutButton">退出登录</button>
        <a class="portal-button-secondary" href="${ADMIN_URL}" target="_blank" rel="noopener">后台管理</a>
      `;
      const logoutButton = actions.querySelector('#portalLogoutButton');
      if (logoutButton) {
        logoutButton.addEventListener('click', function () {
          clearAuth();
          window.location.href = pageUrl('index.html');
        });
      }
    } else {
      actions.innerHTML = `
        <a class="portal-button-secondary" href="${pageUrl('pages/customer/register.html')}">注册</a>
        <a class="portal-button" href="${pageUrl('pages/login/login.html')}">登录</a>
        <a class="portal-button-secondary" href="${ADMIN_URL}" target="_blank" rel="noopener">后台管理</a>
      `;
    }
  }

  window.hotelPortal = {
    ADMIN_URL,
    API_BASE,
    FRONT_BASE,
    api,
    assetUrl,
    avatarMarkup,
    bookingStatusLabel,
    clearAuth,
    currentCustomer,
    emptyState,
    ensureLogin,
    escapeHtml,
    formatDate,
    formatDateTime,
    formatMoney,
    isLoggedIn,
    mountTopbar,
    orderTrackingLabel,
    pageUrl,
    payStatusLabel,
    favoriteTargetHref,
    rememberSelectedRoomId,
    getSelectedRoomId,
    clearSelectedRoomId,
    query,
    roomStatusLabel,
    scoreStars,
    stripHtml,
    toast
  };
})(window);
