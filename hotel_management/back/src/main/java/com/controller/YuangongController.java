package com.controller;

import com.annotation.IgnoreAuth;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.entity.YuangongEntity;
import com.entity.view.YuangongView;
import com.service.TokenService;
import com.service.YuangongService;
import com.utils.MPUtil;
import com.utils.PageUtils;
import com.utils.R;
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
@RequestMapping("/employee")
public class YuangongController {
    @Autowired
    private YuangongService employeeService;

    @Autowired
    private TokenService auth_tokenService;

    @IgnoreAuth
    @RequestMapping(value = "/login")
    public R login(String username, String password, String captcha, HttpServletRequest request) {
        YuangongEntity user = employeeService.selectOne(new EntityWrapper<YuangongEntity>().eq("employeegonghao", username));
        if (user == null || !user.getMima().equals(password)) {
            return R.error("账号或密码不正确");
        }
        String auth_token = auth_tokenService.generateToken(user.getId(), username, "employee", "员工");
        return R.ok().put("auth_token", auth_token);
    }

    @IgnoreAuth
    @RequestMapping("/register")
    public R register(@RequestBody YuangongEntity employee) {
        YuangongEntity user = employeeService.selectOne(new EntityWrapper<YuangongEntity>().eq("employeegonghao", employee.getYuangonggonghao()));
        if (user != null) {
            return R.error("账号已存在");
        }
        employeeService.insert(employee);
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
        YuangongEntity user = employeeService.selectById(id);
        return R.ok().put("data", user);
    }

    @IgnoreAuth
    @RequestMapping(value = "/resetPass")
    public R resetPass(String username, HttpServletRequest request) {
        YuangongEntity user = employeeService.selectOne(new EntityWrapper<YuangongEntity>().eq("employeegonghao", username));
        if (user == null) {
            return R.error("账号不存在");
        }
        user.setMima("123456");
        employeeService.updateById(user);
        return R.ok("密码已重置为 123456");
    }

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, YuangongEntity employee, HttpServletRequest request) {
        EntityWrapper<YuangongEntity> ew = new EntityWrapper<YuangongEntity>();
        PageUtils page = employeeService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, employee), params), params));
        return R.ok().put("data", page);
    }

    @IgnoreAuth
    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params, YuangongEntity employee, HttpServletRequest request) {
        EntityWrapper<YuangongEntity> ew = new EntityWrapper<YuangongEntity>();
        PageUtils page = employeeService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, employee), params), params));
        return R.ok().put("data", page);
    }

    @RequestMapping("/lists")
    public R list(YuangongEntity employee) {
        EntityWrapper<YuangongEntity> ew = new EntityWrapper<YuangongEntity>();
        ew.allEq(MPUtil.allEQMapPre(employee, "employee"));
        return R.ok().put("data", employeeService.selectListView(ew));
    }

    @RequestMapping("/query")
    public R query(YuangongEntity employee) {
        EntityWrapper<YuangongEntity> ew = new EntityWrapper<YuangongEntity>();
        ew.allEq(MPUtil.allEQMapPre(employee, "employee"));
        YuangongView employeeView = employeeService.selectView(ew);
        return R.ok("查询员工成功").put("data", employeeView);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id) {
        YuangongEntity employee = employeeService.selectById(id);
        return R.ok().put("data", employee);
    }

    @IgnoreAuth
    @RequestMapping("/detail/{id}")
    public R detail(@PathVariable("id") Long id) {
        YuangongEntity employee = employeeService.selectById(id);
        return R.ok().put("data", employee);
    }

    @RequestMapping("/save")
    public R save(@RequestBody YuangongEntity employee, HttpServletRequest request) {
        YuangongEntity user = employeeService.selectOne(new EntityWrapper<YuangongEntity>().eq("employeegonghao", employee.getYuangonggonghao()));
        if (user != null) {
            return R.error("账号已存在");
        }
        employeeService.insert(employee);
        return R.ok();
    }

    @RequestMapping("/add")
    public R add(@RequestBody YuangongEntity employee, HttpServletRequest request) {
        YuangongEntity user = employeeService.selectOne(new EntityWrapper<YuangongEntity>().eq("employeegonghao", employee.getYuangonggonghao()));
        if (user != null) {
            return R.error("账号已存在");
        }
        employeeService.insert(employee);
        return R.ok();
    }

    @RequestMapping("/update")
    public R update(@RequestBody YuangongEntity employee, HttpServletRequest request) {
        employeeService.updateById(employee);
        return R.ok();
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Long[] ids) {
        employeeService.deleteBatchIds(Arrays.asList(ids));
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

        Wrapper<YuangongEntity> wrapper = new EntityWrapper<YuangongEntity>();
        if (map.get("remindstart") != null) {
            wrapper.ge(columnName, map.get("remindstart"));
        }
        if (map.get("remindend") != null) {
            wrapper.le(columnName, map.get("remindend"));
        }

        int count = employeeService.selectCount(wrapper);
        return R.ok().put("count", count);
    }
}
