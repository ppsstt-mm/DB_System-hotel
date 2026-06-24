import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

import Index from '@/views/index'
import Home from '@/views/home'
import Login from '@/views/login'
import NotFound from '@/views/404'
import UpdatePassword from '@/views/update-password'
import Pay from '@/views/pay'
import Register from '@/views/register'
import Center from '@/views/center'
import OperationsReport from '@/views/modules/operations_report/index'
import BookingFlow from '@/views/modules/booking_flow/index'
import ProcedureCenter from '@/views/modules/procedure_center/index'
import OpsCenter from '@/views/modules/ops_center/index'

const moduleRoutes = [
  'hotel_profile',
  'notice',
  'system_config',
  'customer',
  'employee',
  'room_category',
  'room_catalog',
  'room_instance',
  'price_policy',
  'room_status_log',
  'booking_order',
  'booking_room',
  'booking_guest',
  'checkin_assignment',
  'checkin_record',
  'checkin_guest',
  'housekeeping_task',
  'maintenance_record',
  'employee_performance',
  'bill',
  'payment_record',
  'refund_record',
  'favorite',
  'booking_status_log',
  'operation_log',
  'hotel_review',
  'room_review',
  'v_bill_payment_summary',
  'v_booking_detail',
  'v_checkin_guest_detail',
  'v_customer_value_profile',
  'v_housekeeping_task_detail'
].map(name => ({
  path: `/${name}`,
  name,
  component: OpsCenter
}))

const routes = [{
  path: '/index',
  component: Index,
  children: [{
    path: '/',
    name: 'home',
    component: Home
  }, {
    path: '/updatePassword',
    name: 'updatePassword',
    component: UpdatePassword
  }, {
    path: '/pay',
    name: 'pay',
    component: Pay
  }, {
    path: '/center',
    name: 'center',
    component: Center
  }, {
    path: '/booking_flow',
    name: 'booking_flow',
    component: BookingFlow
  }, {
    path: '/procedure_center',
    name: 'procedure_center',
    component: ProcedureCenter
  }, {
    path: '/operations_report',
    name: 'operations_report',
    component: OperationsReport
  }, ...moduleRoutes]
}, {
  path: '/login',
  name: 'login',
  component: Login
}, {
  path: '/register',
  name: 'register',
  component: Register
}, {
  path: '/',
  name: 'root',
  redirect: '/index'
}, {
  path: '*',
  component: NotFound
}]

const router = new VueRouter({
  mode: 'hash',
  routes
})

export default router
