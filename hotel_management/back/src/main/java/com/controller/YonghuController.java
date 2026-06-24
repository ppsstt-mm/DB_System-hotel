package com.controller;

import com.annotation.IgnoreAuth;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.entity.TokenEntity;
import com.entity.YonghuEntity;
import com.entity.view.YonghuView;
import com.service.TokenService;
import com.service.YonghuService;
import com.utils.MPUtil;
import com.utils.PageUtils;
import com.utils.R;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;

@RestController
@RequestMapping("/customer")
public class YonghuController {
    @Autowired
    private YonghuService customerService;

    @Autowired
    private TokenService auth_tokenService;

    private TokenEntity currentToken(HttpServletRequest request) {
        String token = request.getHeader("Token");
        if (StringUtils.isBlank(token)) {
            return null;
        }
        return auth_tokenService.getTokenEntity(token);
    }

    @IgnoreAuth
    @RequestMapping(value = "/login")
    public R login(String username, String password, String captcha, HttpServletRequest request) {
        YonghuEntity user = customerService.selectOne(new EntityWrapper<YonghuEntity>().eq("customerming", username));
        if (user == null || !user.getMima().equals(password)) {
            return R.error("账号或密码不正确");
        }
        String auth_token = auth_tokenService.generateToken(user.getId(), username, "customer", "客户");
        return R.ok().put("auth_token", auth_token);
    }

    @IgnoreAuth
    @RequestMapping("/register")
    public R register(@RequestBody YonghuEntity customer) {
        YonghuEntity user = customerService.selectOne(new EntityWrapper<YonghuEntity>().eq("customerming", customer.getCustomerming()));
        if (user != null) {
            return R.error("账号已存在");
        }
        customerService.insert(customer);
        return R.ok();
    }

    @RequestMapping("/logout")
    public R logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return R.ok("退出成功");
    }

    @RequestMapping("/session")
    public R getCurrUser(HttpServletRequest request) {
        Long id = (Long) request.getSession().getAttribute("userId");
        if (id == null) {
            TokenEntity tokenEntity = currentToken(request);
            if (tokenEntity != null && "customer".equals(tokenEntity.getTablename())) {
                id = tokenEntity.getUserid();
            }
        }
        if (id == null) {
            return R.error(401, "请先登录");
        }
        YonghuEntity user = customerService.selectById(id);
        return R.ok().put("data", user);
    }

    @IgnoreAuth
    @RequestMapping(value = "/resetPass")
    public R resetPass(String username, HttpServletRequest request) {
        YonghuEntity user = customerService.selectOne(new EntityWrapper<YonghuEntity>().eq("customerming", username));
        if (user == null) {
            return R.error("账号不存在");
        }
        user.setMima("123456");
        customerService.updateById(user);
        return R.ok("密码已重置为 123456");
    }

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, YonghuEntity customer, HttpServletRequest request) {
        EntityWrapper<YonghuEntity> ew = new EntityWrapper<YonghuEntity>();
        PageUtils page = customerService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, customer), params), params));
        return R.ok().put("data", page);
    }

    @IgnoreAuth
    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params, YonghuEntity customer, HttpServletRequest request) {
        EntityWrapper<YonghuEntity> ew = new EntityWrapper<YonghuEntity>();
        PageUtils page = customerService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, customer), params), params));
        return R.ok().put("data", page);
    }

    @RequestMapping("/lists")
    public R list(YonghuEntity customer) {
        EntityWrapper<YonghuEntity> ew = new EntityWrapper<YonghuEntity>();
        ew.allEq(MPUtil.allEQMapPre(customer, "customer"));
        return R.ok().put("data", customerService.selectListView(ew));
    }

    @RequestMapping("/query")
    public R query(YonghuEntity customer) {
        EntityWrapper<YonghuEntity> ew = new EntityWrapper<YonghuEntity>();
        ew.allEq(MPUtil.allEQMapPre(customer, "customer"));
        YonghuView customerView = customerService.selectView(ew);
        return R.ok("查询客户成功").put("data", customerView);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id) {
        YonghuEntity customer = customerService.selectById(id);
        return R.ok().put("data", customer);
    }

    @IgnoreAuth
    @RequestMapping("/detail/{id}")
    public R detail(@PathVariable("id") Long id) {
        YonghuEntity customer = customerService.selectById(id);
        return R.ok().put("data", customer);
    }

    @RequestMapping("/save")
    public R save(@RequestBody YonghuEntity customer, HttpServletRequest request) {
        YonghuEntity user = customerService.selectOne(new EntityWrapper<YonghuEntity>().eq("customerming", customer.getCustomerming()));
        if (user != null) {
            return R.error("账号已存在");
        }
        customerService.insert(customer);
        return R.ok();
    }

    @RequestMapping("/add")
    public R add(@RequestBody YonghuEntity customer, HttpServletRequest request) {
        YonghuEntity user = customerService.selectOne(new EntityWrapper<YonghuEntity>().eq("customerming", customer.getCustomerming()));
        if (user != null) {
            return R.error("账号已存在");
        }
        customerService.insert(customer);
        return R.ok();
    }

    @RequestMapping("/update")
    public R update(@RequestBody YonghuEntity customer, HttpServletRequest request) {
        customerService.updateById(customer);
        return R.ok();
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Long[] ids) {
        customerService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    @RequestMapping("/remind/{columnName}/{type}")
    public R remindCount(@PathVariable("columnName") String columnName, HttpServletRequest request,
                         @PathVariable("type") String type, @RequestParam Map<String, Object> map) {
        map.put("column", columnName);
        map.put("type", type);

        if ("2".equals(type)) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Calendar c = Calendar.getInstance();
            if (map.get("remindstart") != null) {
                Integer remindStart = Integer.parseInt(map.get("remindstart").toString());
                c.setTime(new Date());
                c.add(Calendar.DAY_OF_MONTH, remindStart);
                map.put("remindstart", sdf.format(c.getTime()));
            }
            if (map.get("remindend") != null) {
                Integer remindEnd = Integer.parseInt(map.get("remindend").toString());
                c.setTime(new Date());
                c.add(Calendar.DAY_OF_MONTH, remindEnd);
                map.put("remindend", sdf.format(c.getTime()));
            }
        }

        Wrapper<YonghuEntity> wrapper = new EntityWrapper<YonghuEntity>();
        if (map.get("remindstart") != null) {
            wrapper.ge(columnName, map.get("remindstart"));
        }
        if (map.get("remindend") != null) {
            wrapper.le(columnName, map.get("remindend"));
        }

        int count = customerService.selectCount(wrapper);
        return R.ok().put("count", count);
    }
}
