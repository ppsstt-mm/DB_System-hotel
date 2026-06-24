package com.controller;

import com.annotation.IgnoreAuth;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.entity.DiscussjiudianjianjieEntity;
import com.entity.TokenEntity;
import com.entity.view.DiscussjiudianjianjieView;
import com.service.DiscussjiudianjianjieService;
import com.service.TokenService;
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
@RequestMapping("/hotel_review")
public class DiscussjiudianjianjieController {
    @Autowired
    private DiscussjiudianjianjieService hotel_reviewService;

    @Autowired
    private TokenService tokenService;

    private TokenEntity currentToken(HttpServletRequest request) {
        String token = request.getHeader("Token");
        if (StringUtils.isBlank(token)) {
            return null;
        }
        return tokenService.getTokenEntity(token);
    }

    private boolean isCustomer(HttpServletRequest request) {
        Object tableName = request.getSession().getAttribute("tableName");
        if (tableName != null) {
            return "customer".equals(String.valueOf(tableName));
        }
        TokenEntity tokenEntity = currentToken(request);
        return tokenEntity != null && "customer".equals(tokenEntity.getTablename());
    }

    private Long currentUserId(HttpServletRequest request) {
        Object userId = request.getSession().getAttribute("userId");
        if (userId != null) {
            if (userId instanceof Long) {
                return (Long) userId;
            }
            return Long.valueOf(String.valueOf(userId));
        }
        TokenEntity tokenEntity = currentToken(request);
        return tokenEntity == null ? null : tokenEntity.getUserid();
    }

    private String currentNickname(HttpServletRequest request) {
        Object username = request.getSession().getAttribute("username");
        if (username != null) {
            return String.valueOf(username);
        }
        TokenEntity tokenEntity = currentToken(request);
        return tokenEntity == null ? null : tokenEntity.getUsername();
    }

    private void fillReviewAuthor(DiscussjiudianjianjieEntity hotel_review, HttpServletRequest request) {
        if (hotel_review == null || !isCustomer(request)) {
            return;
        }
        hotel_review.setUserid(currentUserId(request));
        if (StringUtils.isBlank(hotel_review.getNickname())) {
            hotel_review.setNickname(currentNickname(request));
        }
        if (hotel_review.getScore() == null || hotel_review.getScore() < 1 || hotel_review.getScore() > 5) {
            hotel_review.setScore(5);
        }
        hotel_review.setReply(null);
    }

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, DiscussjiudianjianjieEntity hotel_review, HttpServletRequest request) {
        EntityWrapper<DiscussjiudianjianjieEntity> ew = new EntityWrapper<DiscussjiudianjianjieEntity>();
        PageUtils page = hotel_reviewService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, hotel_review), params), params));
        return R.ok().put("data", page);
    }

    @IgnoreAuth
    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params, DiscussjiudianjianjieEntity hotel_review, HttpServletRequest request) {
        EntityWrapper<DiscussjiudianjianjieEntity> ew = new EntityWrapper<DiscussjiudianjianjieEntity>();
        PageUtils page = hotel_reviewService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, hotel_review), params), params));
        return R.ok().put("data", page);
    }

    @RequestMapping("/lists")
    public R list(DiscussjiudianjianjieEntity hotel_review) {
        EntityWrapper<DiscussjiudianjianjieEntity> ew = new EntityWrapper<DiscussjiudianjianjieEntity>();
        ew.allEq(MPUtil.allEQMapPre(hotel_review, "hotel_review"));
        return R.ok().put("data", hotel_reviewService.selectListView(ew));
    }

    @RequestMapping("/query")
    public R query(DiscussjiudianjianjieEntity hotel_review) {
        EntityWrapper<DiscussjiudianjianjieEntity> ew = new EntityWrapper<DiscussjiudianjianjieEntity>();
        ew.allEq(MPUtil.allEQMapPre(hotel_review, "hotel_review"));
        DiscussjiudianjianjieView hotel_reviewView = hotel_reviewService.selectView(ew);
        return R.ok("查询酒店评价成功").put("data", hotel_reviewView);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id) {
        DiscussjiudianjianjieEntity hotel_review = hotel_reviewService.selectById(id);
        return R.ok().put("data", hotel_review);
    }

    @IgnoreAuth
    @RequestMapping("/detail/{id}")
    public R detail(@PathVariable("id") Long id) {
        DiscussjiudianjianjieEntity hotel_review = hotel_reviewService.selectById(id);
        return R.ok().put("data", hotel_review);
    }

    @RequestMapping("/save")
    public R save(@RequestBody DiscussjiudianjianjieEntity hotel_review, HttpServletRequest request) {
        fillReviewAuthor(hotel_review, request);
        hotel_reviewService.insert(hotel_review);
        return R.ok();
    }

    @RequestMapping("/add")
    public R add(@RequestBody DiscussjiudianjianjieEntity hotel_review, HttpServletRequest request) {
        fillReviewAuthor(hotel_review, request);
        hotel_reviewService.insert(hotel_review);
        return R.ok();
    }

    @RequestMapping("/update")
    public R update(@RequestBody DiscussjiudianjianjieEntity hotel_review, HttpServletRequest request) {
        hotel_reviewService.updateById(hotel_review);
        return R.ok();
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Long[] ids) {
        hotel_reviewService.deleteBatchIds(Arrays.asList(ids));
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

        Wrapper<DiscussjiudianjianjieEntity> wrapper = new EntityWrapper<DiscussjiudianjianjieEntity>();
        if (map.get("remindstart") != null) {
            wrapper.ge(columnName, map.get("remindstart"));
        }
        if (map.get("remindend") != null) {
            wrapper.le(columnName, map.get("remindend"));
        }

        int count = hotel_reviewService.selectCount(wrapper);
        return R.ok().put("count", count);
    }
}
