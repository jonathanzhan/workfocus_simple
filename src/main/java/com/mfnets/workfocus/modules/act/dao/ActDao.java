/*
 * Copyright  2014-2016 whatlookingfor@gmail.com(Jonathan)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.mfnets.workfocus.modules.act.dao;

import com.mfnets.workfocus.common.persistence.CrudDao;
import com.mfnets.workfocus.common.persistence.annotation.MyBatisDao;
import com.mfnets.workfocus.modules.act.entity.Act;
import com.mfnets.workfocus.modules.act.entity.ActBusiness;

/**
 * 工作流的dao层接口
 *
 * @author Jonathan
 * @version 2016/9/14 17:02
 * @since JDK 7.0+
 */
@MyBatisDao
public interface ActDao extends CrudDao<Act> {

	public int updateProcInsIdByBusinessInfo(ActBusiness actBusiness);
}
