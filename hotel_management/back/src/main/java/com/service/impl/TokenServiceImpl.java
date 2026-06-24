
package com.service.impl;


import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.dao.TokenDao;
import com.entity.TokenEntity;
import com.entity.TokenEntity;
import com.service.TokenService;
import com.utils.CommonUtil;
import com.utils.PageUtils;
import com.utils.Query;


/**
 * auth_token
 */
@Service("auth_tokenService")
public class TokenServiceImpl extends ServiceImpl<TokenDao, TokenEntity> implements TokenService {

	@Override
	public PageUtils queryPage(Map<String, Object> params) {
		Page<TokenEntity> page = this.selectPage(
                new Query<TokenEntity>(params).getPage(),
                new EntityWrapper<TokenEntity>()
        );
        return new PageUtils(page);
	}

	@Override
	public List<TokenEntity> selectListView(Wrapper<TokenEntity> wrapper) {
		return baseMapper.selectListView(wrapper);
	}

	@Override
	public PageUtils queryPage(Map<String, Object> params,
			Wrapper<TokenEntity> wrapper) {
		 Page<TokenEntity> page =new Query<TokenEntity>(params).getPage();
	        page.setRecords(baseMapper.selectListView(page,wrapper));
	    	PageUtils pageUtil = new PageUtils(page);
	    	return pageUtil;
	}

	@Override
	public String generateToken(Long userid,String username, String tableName, String role) {
		TokenEntity auth_tokenEntity = this.selectOne(new EntityWrapper<TokenEntity>().eq("userid", userid).eq("role", role));
		String auth_token = CommonUtil.getRandomString(32);
		Calendar cal = Calendar.getInstance();   
    	cal.setTime(new Date());   
    	cal.add(Calendar.HOUR_OF_DAY, 1);
		if(auth_tokenEntity!=null) {
			auth_tokenEntity.setToken(auth_token);
			auth_tokenEntity.setExpiratedtime(cal.getTime());
			this.updateById(auth_tokenEntity);
		} else {
			this.insert(new TokenEntity(userid,username, tableName, role, auth_token, cal.getTime()));
		}
		return auth_token;
	}

	@Override
	public TokenEntity getTokenEntity(String auth_token) {
		TokenEntity auth_tokenEntity = this.selectOne(new EntityWrapper<TokenEntity>().eq("auth_token", auth_token));
		if(auth_tokenEntity == null || auth_tokenEntity.getExpiratedtime().getTime()<new Date().getTime()) {
			return null;
		}
		return auth_tokenEntity;
	}
}
