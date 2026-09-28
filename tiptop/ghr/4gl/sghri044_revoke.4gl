# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: sghri044_revoke.4gl
# Descriptions...: 撤消请假作业
# Date & Author..: 13/07/24 By yangjian
# Modify ........: NO.130912 13/09/12 by wangxh 职位，性别，部门等显示为名称
# Modify ........: NO.130912_1 13/09/12 by wangxh 职位，性别，部门等显示为名称

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 DEFINE l_revoke   DYNAMIC ARRAY OF RECORD 
            chk      LIKE  type_file.chr1,
            hrcda16  LIKE  hrcda_file.hrcda16,
            hrcda17  LIKE  hrcda_file.hrcda17,
            hrcda03b LIKE  hrcda_file.hrcda03,
            hrcda03b_name  LIKE type_file.chr100,
            hrcda02  LIKE  hrcda_file.hrcda02,
            hrcda01  LIKE  hrcda_file.hrcda01,
            hrcda04  LIKE  hrcda_file.hrcda04,
            hrat02   LIKE  hrat_file.hrat02,
            hrat04   LIKE  hrat_file.hrat04,
            hrat17   LIKE  hrat_file.hrat17,
            hrat05   LIKE  hrat_file.hrat05,
            hrcda05b LIKE  hrcda_file.hrcda05,
            hrcda06  LIKE  hrcda_file.hrcda06,
            hrcda07  LIKE  hrcda_file.hrcda07,
            hrcda08  LIKE  hrcda_file.hrcda08,
            hrcda09  LIKE  hrcda_file.hrcda09,
            hrcda10  LIKE  hrcda_file.hrcda10,
            hrcda15b LIKE  hrcda_file.hrcda15
              END RECORD
  DEFINE g_wc2  STRING,
         g_rec_b         LIKE type_file.num5,      #單身筆數 #130912 add by wangxh130912
         l_ac            LIKE type_file.num5       #目前處理的ARRAY CNT #130912 add by wangxh130912
  DEFINE g_cnt  LIKE type_file.num10
  DEFINE g_sql  STRING
  DEFINE g_inTransaction  BOOLEAN
  DEFINE g_errshow        BOOLEAN
  DEFINE g_hrcc_1  DYNAMIC ARRAY OF RECORD
               hrcc02  LIKE  hrcc_file.hrcc02,
               hrcc04  LIKE  hrcc_file.hrcc04,
               hrcc07  LIKE  hrcc_file.hrcc07,
               hrcc01  LIKE  hrcc_file.hrcc01
                 END RECORD
  DEFINE g_hrch_1  DYNAMIC ARRAY OF RECORD
               hrch01  LIKE  hrch_file.hrch01,
               hrch02  LIKE  hrch_file.hrch02,
               hrch03  LIKE  hrch_file.hrch03,
               hrch19  LIKE  hrch_file.hrch19
                 END RECORD                 
              
FUNCTION sghri044_revoke(p_inTransaction,p_errshow)
 DEFINE p_row,p_col  LIKE  type_file.num5
 DEFINE l_n          LIKE  type_file.num5
 DEFINE l_hrcda16    LIKE  hrcda_file.hrcda16
 DEFINE l_msg        LIKE  type_file.chr1000
 DEFINE p_inTransaction  BOOLEAN
 DEFINE p_errshow        BOOLEAN

    WHENEVER ERROR CONTINUE 
    LET g_inTransaction = p_inTransaction
    LET g_errshow       = p_errshow
    LET g_success = 'Y'
    LET p_row = 5 LET p_col = 22
    OPEN WINDOW i044_w_r AT p_row,p_col WITH FORM "ghr/42f/ghri044_r"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL cl_set_label_justify("i044_w_r","right")

    WHILE TRUE  
      MENU ""
        BEFORE MENU
           CALL cl_set_act_visible("accept,cancel",FALSE)
           
        ON ACTION query
          LET g_action_choice = "query"
          CALL sghri044_revoke_cs()
          CALL sghri044_revoke_b_fill()
          
        ON ACTION detail
          LET g_action_choice = "detail"
          CALL sghri044_revoke_b()
          
        ON ACTION accept
          LET g_action_choice = "detail"
          CALL sghri044_revoke_b()
          
        ON ACTION done_exit
          LET g_action_choice="done_exit"
          CALL revoke_ri044cs()          #add by wangxh130916
          CALL sghri044_revoke_process()
          CALL sghri044_revoke_b_fill()
                 
        ON ACTION controlg
          CALL cl_cmdask()
          
        ON ACTION close
          LET g_action_choice = "exit"
          EXIT MENU  
        
        ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU
          
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
       END MENU
       CALL cl_set_act_visible("accept,cancel",TRUE)
       EXIT WHILE
    END WHILE   
    CLOSE WINDOW i044_w_r 
END FUNCTION

FUNCTION sghri044_revoke_cs()  
DEFINE l_wc  STRING  

    CALL l_revoke.clear()
    CLEAR FORM
    CALL cl_set_act_visible("accept,cancel",TRUE)           
    CONSTRUCT g_wc2 ON hrcda03,hrcda05,hrcda15,hrcda16,hrcda17,hrcda04,hrcda06,hrcda07,hrcda08,hrcda09,hrcda10 FROM 
       hrcda03,hrcda05,hrcda15, s_revoke[1].hrcda16,s_revoke[1].hrcda17,s_revoke[1].hrcda04,s_revoke[1].hrcda06,
       s_revoke[1].hrcda07,s_revoke[1].hrcda08,s_revoke[1].hrcda09,s_revoke[1].hrcda10
       
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
          
          ON ACTION controlp
             CASE 
               WHEN INFIELD(hrcda03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcda03
                 NEXT FIELD hrcda03
              END CASE 
              
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about         #MOD-4C0121
            CALL cl_about()       #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
             
          ON ACTION qbe_select
             CALL cl_qbe_select() 
          ON ACTION qbe_save
             CALL cl_qbe_save()
    END CONSTRUCT
    CALL cl_replace_str(g_wc2,"hrcda04","hrat01") RETURNING g_wc2
    CALL cl_get_hrzxa(g_user) RETURNING l_wc 
    LET g_wc2 = g_wc2 CLIPPED," AND ",l_wc CLIPPED 
    CALL cl_set_act_visible("accept,cancel",FALSE)
    IF INT_FLAG THEN 
    	 LET INT_FLAG = 0
    END IF 

END FUNCTION

FUNCTION sghri044_revoke_b_fill()    
    LET g_cnt = 1
    CALL l_revoke.clear() 

    LET g_sql = "SELECT 'N',hrcda16,hrcda17,hrcda03,hrbm04,hrcda02,hrcda01,hrcda04,hrat02,hrat04,hrat17,hrat05,hrcda05,hrcda06,hrcda07,hrcda08,",
                "        hrcda09,hrcda10,hrcda15 ",
                "  FROM hrcda_file,hrat_file,hrbm_file",
                " WHERE ",g_wc2 CLIPPED,
                "   AND hratid(+) = hrcda04 ",
                "   AND hrbm03(+) = hrcda03 ",
              # "   AND hrcda16 = 'N' ",
                " ORDER BY hrcda04,hrcda02,hrcda01"
    PREPARE i044_revoke_prep FROM g_sql
    DECLARE i044_revoke_cs CURSOR FOR i044_revoke_prep
    FOREACH i044_revoke_cs  INTO l_revoke[g_cnt].*
       IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
        #130912 add by wangxh --str--
      IF NOT cl_null(l_revoke[g_cnt].hrat04) THEN
         SELECT hrao02 INTO l_revoke[g_cnt].hrat04 FROM hrao_file WHERE hrao01=l_revoke[g_cnt].hrat04
      END IF
      IF NOT cl_null(l_revoke[g_cnt].hrat05) THEN
         SELECT hras04 INTO l_revoke[g_cnt].hrat05 FROM hras_file WHERE hras01=l_revoke[g_cnt].hrat05
      END IF
      IF NOT cl_null(l_revoke[g_cnt].hrat17) THEN
         SELECT hrag07 INTO l_revoke[g_cnt].hrat17 FROM hrag_file 
           WHERE hrag06=l_revoke[g_cnt].hrat17 AND hrag01='333'
      END IF
    
        IF NOT cl_null(l_revoke[g_cnt].hrcda10) THEN 
        CASE l_revoke[g_cnt].hrcda10
             WHEN '001'  LET l_revoke[g_cnt].hrcda10='天'
             WHEN '002'  LET l_revoke[g_cnt].hrcda10='半天'
             WHEN '003'  LET l_revoke[g_cnt].hrcda10='小时'
             WHEN '004'  LET l_revoke[g_cnt].hrcda10='分钟'
             WHEN '005'  LET l_revoke[g_cnt].hrcda10='次'
         END CASE
       END IF
   
    #130912 add by wangxh --end--
       LET g_cnt = g_cnt + 1 
    END FOREACH
    CALL l_revoke.deleteElement(g_cnt)
    LET g_cnt = g_cnt - 1 
    DISPLAY g_cnt TO FORMONLY.cn2
    
    DISPLAY ARRAY l_revoke TO s_revoke.*
       BEFORE DISPLAY 
          EXIT DISPLAY
    
    END DISPLAY 
    
END FUNCTION 

FUNCTION sghri044_revoke_b()   
 DEFINE i  LIKE  type_file.num10
 
    INPUT ARRAY l_revoke WITHOUT DEFAULTS FROM s_revoke.*
      ATTRIBUTE (COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
                 
         BEFORE INPUT
            CALL fgl_set_arr_curr(1)
            CALL cl_set_act_visible("accept,cancel",TRUE)
            CALL cl_set_comp_entry("hrcda16,hrcda02,hrcda01,hrcda04,hrat02,hrat04,hrat17",FALSE)
            CALL cl_set_comp_entry("hrat05,hrcda05b,hrcda06,hrcda07,hrcda08,hrcda09,hrcda10,hrcda15b",FALSE)
            CALL cl_set_comp_entry("hrcda17,hrcda03b,hrcda03b_name",FALSE)
              
 
          ON ACTION CONTROLG
             CALL cl_cmdask()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
          ON ACTION help       
             CALL cl_show_help()  
             
          ON ACTION sel_all
             FOR i = 1 TO g_cnt
                LET l_revoke[i].chk = 'Y'
             END FOR
             
          ON ACTION sel_none
             FOR i = 1 TO g_cnt
                LET l_revoke[i].chk = 'N'
             END FOR             
        
    END INPUT
    CALL cl_set_act_visible("accept,cancel",FALSE)
    IF INT_FLAG THEN 
    	 LET INT_FLAG = 0
    END IF 
END FUNCTION

FUNCTION sghri044_revoke_process()
  DEFINE l_n,i        LIKE  type_file.num10
  DEFINE l_hrcda16  LIKE  hrcda_file.hrcda16
  DEFINE l_msg      STRING
  

      
    IF NOT cl_confirm('abx-080') THEN 
    	 RETURN
    END IF 
    
    IF NOT g_inTransaction THEN 
       BEGIN WORK
    END IF 
    CALL g_hrch_1.clear()
    CALL g_hrcc_1.clear()
    FOR l_n = 1 TO g_cnt
       IF l_revoke[l_n].chk = 'Y' THEN
          IF l_revoke[l_n].hrcda16 = 'Y' THEN LET l_hrcda16 = 'N' 
          ELSE LET l_hrcda16 = 'Y' 
          END IF 
          LET l_msg = "是否撤消 "||l_revoke[l_n].hrcda04||l_revoke[l_n].hrat02||" "
          IF cl_null(l_revoke[l_n].hrcda05b) THEN
          	 LET l_msg = l_msg||" 的休假信息"
          ELSE 
             LET l_msg = l_msg||l_revoke[l_n].hrcda05b||" 的休假信息"
          END IF 
          IF NOT cl_confirm(l_msg) THEN CONTINUE FOR END IF 
          UPDATE hrcda_file SET hrcda16 = l_hrcda16 WHERE hrcda01 = l_revoke[l_n].hrcda01
       	     AND hrcda02 = l_revoke[l_n].hrcda02
       	  IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             IF g_errshow THEN
                CALL cl_err('','ghr-110',1)
             ELSE 
                CALL s_errmsg('hrcda02',l_revoke[l_n].hrcda02,'','ghr-110',1)
             END IF 
       	     EXIT FOR
          END IF 
          IF l_hrcda16 = 'Y' THEN 
             CALL sghri044_revoke_dayReturn(l_n)
          ELSE 
             CALL sghri044_revoke_day(l_n)
          END IF 
       END IF 
    END FOR
    IF g_success = 'Y' THEN 
    	 FOR i = 1 TO g_hrcc_1.getLength()
    	    UPDATE hrcc_file SET hrcc09 = 0
           WHERE hrcc01 = g_hrcc_1[i].hrcc01
             AND hrcc02 = g_hrcc_1[i].hrcc02
             AND hrcc04 = g_hrcc_1[i].hrcc04
             AND hrcc07 = g_hrcc_1[i].hrcc07
          IF SQLCA.sqlcode THEN 
             LET g_success = 'N'
             IF g_errshow THEN
                CALL cl_err('',SQLCA.sqlcode,1)
             ELSE 
                LET l_msg = 'upd hrcc clear day'
                CALL s_errmsg('hrcc01',g_hrcc_1[i].hrcc01,l_msg,sqlca.sqlcode,1)
             END IF 
          END IF 
     	 END FOR   
     	 FOR i = 1 TO g_hrch_1.getLength()
          UPDATE hrch_file SET hrch06 = 0,hrch20=0,hrch21=0,hrch22=0
           WHERE hrch01 = g_hrch_1[i].hrch01
             AND hrch02 = g_hrch_1[i].hrch02
             AND hrch03 = g_hrch_1[i].hrch03   
             AND hrch19 = g_hrch_1[i].hrch19  
          IF SQLCA.sqlcode THEN 
             LET g_success = 'N'
             IF g_errshow THEN
                CALL cl_err('',SQLCA.sqlcode,1)
             ELSE 
                LET l_msg = 'upd hrch clear day'
                CALL s_errmsg('hrch19',g_hrch_1[i].hrch19,l_msg,sqlca.sqlcode,1)
             END IF 
          END IF                 	    
       END FOR
    END IF  
    IF g_success = 'Y' THEN
       IF NOT g_inTransaction THEN COMMIT WORK END IF 
       CALL cl_err('','abm-019',1)
    ELSE 
       IF NOT g_inTransaction THEN ROLLBACK WORK END IF 
    END IF 
    CALL s_showmsg()

END FUNCTION

FUNCTION sghri044_revoke_dayReturn(l_n)
  DEFINE l_n   LIKE type_file.num5
  DEFINE l_msg STRING
  DEFINE l_hrcda  RECORD  LIKE hrcda_file.*
  
  SELECT * INTO l_hrcda.* FROM hrcda_file
   WHERE hrcda01 = l_revoke[l_n].hrcda01
     AND hrcda02 = l_revoke[l_n].hrcda02
  IF SQLCA.sqlcode THEN 
  	 LET g_success = 'N'
  	 IF g_errshow THEN 
  	   CALL cl_err('','ghr-143',1)
  	 ELSE 
  	    LET l_msg = l_hrcda.hrcda02
  	    CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,'ghr-143',1)
  	 END IF 
  END IF    
  CASE l_hrcda.hrcda17
     WHEN '1'   #特殊假
        CALL sghri044_revoke_dayReturn2(l_hrcda.*)
     WHEN '2'   #年假
        CALL sghri044_revoke_dayReturn3(l_hrcda.*)
     WHEN '3'   #调休假
        CALL sghri044_revoke_dayReturn4(l_hrcda.*)
     WHEN '4'   #普通假
     OTHERWISE
        #无此请假类型
         LET g_success = 'N'
         IF g_errshow THEN
            CALL cl_err('','ghr-145',1)
         ELSE 
            LET l_msg = l_hrcda.hrcda02
            CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,'ghr-145',1)
         END IF 
  END CASE 
END FUNCTION 

FUNCTION sghri044_revoke_day(l_n)
  DEFINE l_n   LIKE type_file.num5
  DEFINE l_msg STRING
  DEFINE l_hrcda  RECORD  LIKE hrcda_file.*
  
  SELECT * INTO l_hrcda.* FROM hrcda_file
   WHERE hrcda01 = l_revoke[l_n].hrcda01
     AND hrcda02 = l_revoke[l_n].hrcda02
  IF SQLCA.sqlcode THEN 
  	 LET g_success = 'N'
  	 IF g_errshow THEN 
  	   CALL cl_err('','ghr-143',1)
  	 ELSE 
  	    LET l_msg = l_hrcda.hrcda02
  	    CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,'ghr-143',1)
  	 END IF 
  END IF    
  CASE l_hrcda.hrcda17
     WHEN '1'   #特殊假
        CALL sghri044_revoke_day2(l_hrcda.*)
     WHEN '2'   #年假
        CALL sghri044_revoke_day3(l_hrcda.*)
     WHEN '3'   #调休假
        CALL sghri044_revoke_day4(l_hrcda.*)
     WHEN '4'   #普通假
     OTHERWISE
        #无此请假类型
         LET g_success = 'N'
         IF g_errshow THEN
            CALL cl_err('','ghr-145',1)
         ELSE 
            LET l_msg = l_hrcda.hrcda02
            CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,'ghr-145',1)
         END IF 
  END CASE 
END FUNCTION 


FUNCTION sghri044_revoke_dayReturn2(l_hrcda)
  DEFINE l_n   LIKE  type_file.num10
  DEFINE l_msg STRING
  DEFINE l_hrcda  RECORD  LIKE hrcda_file.*
  DEFINE l_hrcdb  RECORD  LIKE hrcdb_file.*
  DEFINE l_hrcc   RECORD  LIKE hrcc_file.*  
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06
  
    LET g_sql = "SELECT hrcc_file.*,hrcdb_file.* FROM hrcc_file,hrcdb_file ",
                " WHERE hrcdb01 = '",l_hrcda.hrcda02,"' ",
                "   AND hrcdb02 = '",l_hrcda.hrcda01,"' ",
                "   AND hrcdb03 = hrcc01 ",
                "   AND hrcc07  = '",l_hrcda.hrcda04,"' "
    PREPARE sghri044_revoke_return2_prep FROM g_sql
    DECLARE sghri044_revoke_return2_cs CURSOR FOR sghri044_revoke_return2_prep
    FOREACH sghri044_revoke_return2_cs INTO l_hrcc.*,l_hrcdb.*
       #单次休完的特殊假
       IF l_hrcc.hrcc06 = 'Y' THEN 
       	  CALL sghri044__umf(l_hrcdb.hrcdb04,l_hrcdb.hrcdb05,l_hrcc.hrcc10) RETURNING l_umf_day
          UPDATE hrcc_file SET hrcc08 = hrcc08 -l_umf_day
           WHERE hrcc01 = l_hrcdb.hrcdb03 
             AND hrcc07 = l_hrcda.hrcda04
          IF SQLCA.sqlcode THEN 
       	     LET g_success = 'N'
             IF g_errshow THEN
                CALL cl_err('',SQLCA.sqlcode,1)
       	     ELSE 
                LET l_msg = 'upd hrcc return 2.1'
                CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,sqlca.sqlcode,1)
       	     END IF 
          END IF 
          #检查下请假档中是否还存在该员工的这次特殊假单，如果没有
          #需要将单次休完的特殊假还原回去
          SELECT COUNT(*) INTO l_n FROM  hrcda_file,hrcdb_file
           WHERE hrcdb03 = l_hrcdb.hrcdb03
             AND hrcda01 = hrcdb02
             AND hrcda02 = hrcdb01
             AND hrcda04 = l_hrcda.hrcda04
             AND hrcda16 = 'N'
          IF l_n = 0 THEN 
             UPDATE hrcc_file SET hrcc08 = 0 , hrcc09 = hrcc03
       	      WHERE hrcc01 = l_hrcda.hrcda18
       	        AND hrcc07 = l_hrcda.hrcda04
             IF SQLCA.sqlcode THEN 
         	      LET g_success = 'N'
                IF g_errshow THEN
                   CALL cl_err('',SQLCA.sqlcode,1)
                ELSE 
                   LET l_msg = 'upd hrcc return 2.2'
                   CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,sqlca.sqlcode,1)
                END IF 
             END IF            	  	    
          END IF 
       ELSE 
          CALL sghri044__umf(l_hrcdb.hrcdb04,l_hrcdb.hrcdb05,l_hrcc.hrcc10) RETURNING l_umf_day
          UPDATE hrcc_file SET hrcc08 = hrcc08 -l_umf_day ,hrcc09 = hrcc09 +l_umf_day
           WHERE hrcc01 = l_hrcdb.hrcdb03 
             AND hrcc07 = l_hrcda.hrcda04
          IF SQLCA.sqlcode THEN 
       	     LET g_success = 'N'
             IF g_errshow THEN
                CALL cl_err('',SQLCA.sqlcode,1)
       	     ELSE 
                LET l_msg = 'upd hrcc return 2.3'
                CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,sqlca.sqlcode,1)
       	     END IF 
          END IF 
       END IF 
    END FOREACH
END FUNCTION

FUNCTION sghri044_revoke_dayReturn3(l_hrcda)
  DEFINE l_n   LIKE  type_file.num10
  DEFINE l_msg STRING
  DEFINE l_hrcda  RECORD  LIKE hrcda_file.*
  DEFINE l_hrcdb  RECORD  LIKE hrcdb_file.*
  DEFINE l_hrch   RECORD  LIKE hrch_file.*
  DEFINE l_hrcf26 LIKE hrcf_file.hrcf26
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06
  
     LET g_sql = "SELECT hrch_file.*,hrcdb_file.* FROM hrch_file,hrcdb_file",
                 " WHERE hrch03 = '",l_hrcda.hrcda04,"' ",
                 "   AND hrch19 = hrcdb03 ",
                 "   AND hrcdb01 = '",l_hrcda.hrcda02,"' ",
                 "   AND hrcdb02 = '",l_hrcda.hrcda01,"' "
     PREPARE sghri044_revoke_return3_prep FROM g_sql
     DECLARE sghri044_revoke_return3_cs CURSOR FOR sghri044_revoke_return3_prep
     FOREACH sghri044_revoke_return3_cs INTO l_hrch.*,l_hrcdb.*                 
           #case 1 ..回加天数到调整年假上
           CALL sghri044__umf(l_hrcdb.hrcdb04,l_hrcdb.hrcdb05,'001') RETURNING l_umf_day
           IF l_hrch.hrch11 > 0 AND l_hrch.hrch22 < l_hrch.hrch11 THEN 
              UPDATE hrch_file SET hrch17 = hrch17+l_umf_day ,hrch22 = hrch22+l_umf_day
               WHERE hrch03 = l_hrcda.hrcda04
                 AND hrch19 = l_hrcdb.hrcdb03
              IF SQLCA.sqlcode THEN 
            	    LET g_success = 'N'
            	    IF g_errshow THEN
                    CALL cl_err('',SQLCA.sqlcode,1)
                  ELSE 
                    LET l_msg = 'upd hrch return 3.1'
                    CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,sqlca.sqlcode,1)
           	      END IF 
              END IF 
           ELSE 
              #case 2 ..回写天数到福利年假上
              IF l_hrch.hrch10 > 0 AND l_hrch.hrch21 < l_hrch.hrch10 THEN 
              	 UPDATE hrch_file SET hrch17 = hrch17+l_umf_day ,hrch21 = hrch21+l_umf_day
           	      WHERE hrch03 = l_hrcda.hrcda04
           	        AND hrch19 = l_hrcdb.hrcdb03  
                 IF SQLCA.sqlcode THEN 
                 	  LET g_success = 'N'
                    IF g_errshow THEN
                       CALL cl_err('',SQLCA.sqlcode,1)
                    ELSE 
                        LET l_msg = 'upd hrch return 3.2'
                        CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,sqlca.sqlcode,1)
                    END IF 
                 END IF            	        
           	  ELSE 
           	     #case 3 ..回写天数到法定年假上
           	     IF l_hrch.hrch09 > 0 AND l_hrch.hrch20 < l_hrch.hrch09 THEN
              	    UPDATE hrch_file SET hrch17 = hrch17+l_umf_day ,hrch20 = hrch20+l_umf_day
           	         WHERE hrch03 = l_hrcda.hrcda04
           	           AND hrch19 = l_hrcdb.hrcdb03 
                    IF SQLCA.sqlcode THEN 
                    	  LET g_success = 'N'
                        IF g_errshow THEN
                    	  	  CALL cl_err('',SQLCA.sqlcode,1)
                    	  ELSE 
                    	  	  LET l_msg = 'upd hrch return 3.3'
                    	  	  CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,sqlca.sqlcode,1)
                    	  END IF 
                    END IF            	             
           	     ELSE 
           	        #case 4 ..回写天数到结余年假上
           	        IF l_hrch.hrch04 > 0 AND l_hrch.hrch06 < l_hrch.hrch04 THEN
              	       UPDATE hrch_file SET hrch17 = hrch17+l_umf_day ,hrch06 = hrch06+l_umf_day
           	            WHERE hrch03 = l_hrcda.hrcda04
           	              AND hrch19 = l_hrcdb.hrcdb03  
                       IF SQLCA.sqlcode THEN 
                       	  LET g_success = 'N'
                          IF g_errshow THEN
                             CALL cl_err('',SQLCA.sqlcode,1)
                       	  ELSE 
                             LET l_msg = 'upd hrch return 3.4'
                             CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,sqlca.sqlcode,1)
                       	  END IF 
                       END IF            	              
           	        ELSE
           	           #case 5 ..报错，没有可以回加的年假
           	            LET g_success = 'N'
  	                    IF g_errshow THEN 
  	 	                     CALL cl_err('','ghr-144',1)
         	              ELSE 
  	                       LET l_msg = ''
  	                       CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,'ghr-144',1)
  	                    END IF 
           	        END IF 
           	     END IF 
           	  END IF 
           END IF
           #检查下请假档中是否还存在该员工的这次年假请假单，如果没有
           #需要将单次休完的年假还原回去
           IF g_success = 'Y' THEN 
              SELECT COUNT(*) INTO l_n FROM  hrcda_file,hrcdb_file
               WHERE hrcda01 = hrcdb02
                 AND hrcda02 = hrcdb01
                 AND hrcdb03 = l_hrcdb.hrcdb03
                 AND hrcda04 = l_hrcda.hrcda04
                 AND hrcda02 = l_hrcda.hrcda02
                 AND hrcda16 = 'N'
              IF l_n =0 THEN 
              	  SELECT hrcf26 INTO l_hrcf26 FROM hrcf_file,hrat_file
              	   WHERE hrcf01 = hrat02
              	     AND hrcf02 = hrat03
              	  IF SQLCA.sqlcode = 100 THEN
              	     SELECT hrcf26 INTO l_hrcf26 FROM hrcf_file,hrat_file
              	      WHERE hrcf01 = hrat02
              	        AND hrcf02 = ' '
              	  END IF 
              	  IF l_hrcf26 IS NULL THEN LET l_hrcf26 = 'N' END IF   	  	 
              	  IF l_hrcf26 = 'Y' THEN 
              	  	 UPDATE hrch_file SET hrch17 =hrch15 , hrcc06 = hrcc04 ,
              	  	        hrch20 =hrch09 ,hrch21 =hrch10 ,hrch22 =hrch11
              	  	  WHERE hrch03 = l_hrcda.hrcda04
              	  	    AND hrch19 = l_hrcdb.hrcdb03
                     IF SQLCA.sqlcode THEN 
                        LET g_success = 'N'
                        IF g_errshow THEN
                           CALL cl_err('',SQLCA.sqlcode,1)
                        ELSE 
                           LET l_msg = 'upd hrch return 3.5'
                           CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,sqlca.sqlcode,1)
                        END IF 
                     END IF               	  	    
              	  END IF  
              END IF 
           END IF 
      END FOREACH
END FUNCTION

FUNCTION sghri044_revoke_dayReturn4(l_hrcda)
  DEFINE l_n   LIKE  type_file.num10
  DEFINE l_msg STRING
  DEFINE l_hrcda  RECORD  LIKE hrcda_file.*
  DEFINE l_hrcdb  RECORD  LIKE hrcdb_file.*
  DEFINE l_hrci   RECORD  LIKE hrci_file.*
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06
    
     LET g_sql = "SELECT hrci_file.*,hrcdb_file.* FROM hrci_file,hrcdb_file ",
                    " WHERE hrci01 = hrcdb03 ",
                    "   AND hrci02 = '",l_hrcda.hrcda04,"' ",
                    "   AND hrcdb01 = '",l_hrcda.hrcda02,"' ",
                    "   AND hrcdb02 = '",l_hrcda.hrcda01,"' "
     PREPARE sghri044_revoke_return4_prep FROM g_sql
     DECLARE sghri044_revoke_return4_cs CURSOR FOR sghri044_revoke_return4_prep
     FOREACH sghri044_revoke_return4_cs INTO l_hrci.*,l_hrcdb.*    
           CALL sghri044__umf(l_hrcdb.hrcdb04,l_hrcdb.hrcdb05,'003') RETURNING l_umf_day                          
           UPDATE hrci_file SET hrci08 = hrci08-l_umf_day ,hrci09 = hrci09+l_umf_day
            WHERE hrci01 = l_hrcdb.hrcdb03
              AND hrci02 = l_hrcda.hrcda04
           IF SQLCA.sqlcode THEN 
              LET g_success = 'N'
              IF g_errshow THEN
                CALL cl_err('',SQLCA.sqlcode,1)
              ELSE 
                LET l_msg = 'upd hrch return 4.1'
                CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,sqlca.sqlcode,1)
              END IF 
           END IF               
    END FOREACH
END FUNCTION


FUNCTION sghri044_revoke_day2(l_hrcda)
  DEFINE l_n   LIKE  type_file.num10
  DEFINE l_msg STRING
  DEFINE l_hrcda  RECORD  LIKE hrcda_file.*
  DEFINE l_hrcdb  RECORD  LIKE hrcdb_file.*
  DEFINE l_hrcc   RECORD  LIKE hrcc_file.*
  DEFINE l_sql    STRING
  DEFINE l_day    LIKE type_file.dat
  DEFINE l_hrcc02 LIKE hrcc_file.hrcc02
  DEFINE l_hrcc04 LIKE hrcc_file.hrcc04
  DEFINE l_hrcc07 LIKE hrcc_file.hrcc07
  DEFINE l_des    BOOLEAN      
  DEFINE l_hrat01 LIKE hrat_file.hrat01
  DEFINE l_hrat02 LIKE hrat_file.hrat02
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06  
  
      LET g_sql = "SELECT hrcc_file.*,hrcdb_file.* FROM hrcc_file,hrcdb_file ",
                  " WHERE hrcc01 = hrcdb03 ",
                  "   AND hrcc07 = '",l_hrcda.hrcda04,"' ",
                  "   AND hrcdb01 = '",l_hrcda.hrcda02,"' ",
                  "   AND hrcdb02 = '",l_hrcda.hrcda01,"' "
      PREPARE sghri044_revoke_p2chk_prep FROM g_sql
      DECLARE sghri044_revoke_p2chk_cs CURSOR FOR sghri044_revoke_p2chk_prep
      FOREACH sghri044_revoke_p2chk_cs INTO l_hrcc.*,l_hrcdb.*
           CALL sghri044_revoke_p2_chk(l_hrcdb.*,l_hrcc.*) RETURNING l_des
           IF NOT l_des THEN 
              LET g_success = 'N'
              SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid = l_hrcda.hrcda04
              LET l_msg = l_day
              IF g_errshow THEN 
             	   CALL cl_err(l_msg,'ghr-136',1)
              ELSE 
                 CALL s_errmsg('hrat01',l_hrat01||l_hrat02,l_msg,'ghr-136',1)
              END IF 
              EXIT FOREACH
           ELSE 
              IF l_hrcc.hrcc06 = 'Y' THEN 
              	 CALL g_hrcc_1.appendElement()
              	 LET g_hrcc_1[g_hrcc_1.getLength()].hrcc02 = l_hrcc.hrcc02
              	 LET g_hrcc_1[g_hrcc_1.getLength()].hrcc04 = l_hrcc.hrcc04
              	 LET g_hrcc_1[g_hrcc_1.getLength()].hrcc07 = l_hrcc.hrcc07
              	 LET g_hrcc_1[g_hrcc_1.getLength()].hrcc01 = l_hrcc.hrcc01
              END IF
              CALL sghri044__umf(l_hrcdb.hrcdb04,l_hrcdb.hrcdb05,l_hrcc.hrcc10) RETURNING l_umf_day 
              UPDATE hrcc_file SET hrcc08 = hrcc08+l_umf_day ,hrcc09 = hrcc09-l_umf_day
               WHERE hrcc01 = l_hrcdb.hrcdb03
                 AND hrcc07 = l_hrcda.hrcda04
              IF SQLCA.sqlcode THEN 
             	   LET g_success = 'N'
                 IF g_errshow THEN
                    CALL cl_err('',SQLCA.sqlcode,1)
                 ELSE 
                    LET l_msg = 'upd hrcc chk 2.1'
                    CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,sqlca.sqlcode,1)
                 END IF 
              END IF 
           END IF 
      END FOREACH
END FUNCTION

FUNCTION sghri044_revoke_p2_chk(l_hrcdb,l_hrcc) 
  DEFINE l_hrcdb   RECORD  LIKE hrcdb_file.*
  DEFINE l_hrcc    RECORD  LIKE hrcc_file.*
  DEFINE l_des     BOOLEAN
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06 
    
    LET l_des = TRUE
    
    CALL sghri044__umf(l_hrcdb.hrcdb04,l_hrcdb.hrcdb05,l_hrcc.hrcc10) RETURNING l_umf_day
    IF l_hrcc.hrcc09 >= l_umf_day THEN 
    	  LET l_des = TRUE
    ELSE 
        LET l_des = FALSE
    END IF 
    RETURN l_des
END FUNCTION

FUNCTION sghri044_revoke_day3(l_hrcda)
  DEFINE l_n   LIKE  type_file.num10
  DEFINE l_msg STRING
  DEFINE l_hrcda  RECORD  LIKE hrcda_file.*
  DEFINE l_hrcdb  RECORD  LIKE hrcdb_file.*
  DEFINE l_hrch   RECORD  LIKE hrch_file.*
  DEFINE l_hrcf   RECORD  LIKE hrcf_file.*
  DEFINE l_des    BOOLEAN       
  DEFINE l_day     LIKE type_file.dat 
  DEFINE l_type    LIKE type_file.chr1	
  DEFINE l_hrat01  LIKE hrat_file.hrat01
  DEFINE l_hrat02  LIKE hrat_file.hrat02
  DEFINE l_hrch20  LIKE hrch_file.hrch20
  DEFINE l_hrch21  LIKE hrch_file.hrch21
  DEFINE l_hrch22  LIKE hrch_file.hrch22
  DEFINE l_umf_day,l_avl_day  LIKE hrcd_file.hrcd06 

      SELECT hrcf_file.* INTO l_hrcf.* FROM hrcf_file,hrat_file
       WHERE hrcf01 = hrat03
         AND hrcf02 = hrat04
         AND hratid = l_hrcda.hrcda04
      IF SQLCA.sqlcode = 100 THEN
         SELECT hrcf_file.* INTO l_hrcf.* FROM hrcf_file,hrat_file
          WHERE hrcf01 = hrat03
            AND hrcf02 = ' '
            AND hratid = l_hrcda.hrcda04
      END IF 
          
      LET g_sql = "SELECT hrch_file.*,hrcdb_file.* FROM hrch_file,hrcdb_file ",
                  " WHERE hrch19 = hrcdb03 ",
                  "   AND hrch03 = '",l_hrcda.hrcda04,"' ",
                  "   AND hrcdb01 = '",l_hrcda.hrcda02,"' ",
                  "   AND hrcdb02 = '",l_hrcda.hrcda01,"' "
      PREPARE sghri044_revoke_p3chk_prep FROM g_sql
      DECLARE sghri044_revoke_p3chk_cs CURSOR FOR sghri044_revoke_p3chk_prep
      FOREACH sghri044_revoke_p3chk_cs INTO l_hrch.*,l_hrcdb.*   
         CALL sghri044_revoke_p3_chk(l_hrcdb.*,l_hrch.*) RETURNING l_des
         IF NOT l_des THEN 
            LET g_success = 'N'
            SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid = l_hrcda.hrcda04
            LET l_msg = l_day
            IF g_errshow THEN 
              CALL cl_err(l_msg,'ghr-141',1)
            ELSE 
              CALL s_errmsg('hrat01',l_hrat01||l_hrat02,l_msg,'ghr-141',1)
            END IF 
            EXIT FOREACH
         END IF
         
         CALL sghri044__umf(l_hrcdb.hrcdb04,l_hrcdb.hrcdb05,'001') RETURNING l_umf_day
         CASE l_hrcdb.hrcdb06
            WHEN '1'
               UPDATE hrch_file SET hrch17 = hrch17 - l_umf_day,hrch06 = hrch06 - l_umf_day
                WHERE hrch01 = l_hrch.hrch01
                  AND hrch02 = l_hrch.hrch02
                  AND hrch03 = l_hrch.hrch03
                  AND hrch19 = l_hrch.hrch19
            WHEN '2'
               LET l_hrch20=0   LET l_hrch21=0   LET l_hrch22=0
               LET l_avl_day = l_umf_day
               SELECT hrch20,hrch21,hrch22 INTO l_hrch20,l_hrch21,l_hrch22 
                 FROM hrch_file
                WHERE hrch01 = l_hrch.hrch01
                  AND hrch02 = l_hrch.hrch02
                  AND hrch03 = l_hrch.hrch03
               WHILE TRUE
                  IF l_avl_day <=0 THEN EXIT WHILE END IF 
                  #法定假
                  IF l_hrch20 >0 AND l_hrch20 >= l_avl_day THEN 
         	           UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch20 = hrch20 - l_avl_day
                      WHERE hrch01 = l_hrch.hrch01
                        AND hrch02 = l_hrch.hrch02
                        AND hrch03 = l_hrch.hrch03
                     LET l_avl_day = 0
                  ELSE 
         	           UPDATE hrch_file SET hrch17 = hrch17 - l_hrch20,hrch20 = hrch20 - l_hrch20
                      WHERE hrch01 = l_hrch.hrch01
                        AND hrch02 = l_hrch.hrch02
                        AND hrch03 = l_hrch.hrch03
                     LET l_hrch20 = 0 
                     LET l_avl_day = l_avl_day - l_hrch20
                  END IF 
                  #福利假
                  IF l_hrch21 >0 AND l_hrch21 >= l_avl_day THEN 
         	           UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch21 = hrch21 - l_avl_day
                      WHERE hrch01 = l_hrch.hrch01
                        AND hrch02 = l_hrch.hrch02
                        AND hrch03 = l_hrch.hrch03
                     LET l_avl_day = 0
                  ELSE 
         	           UPDATE hrch_file SET hrch17 = hrch17 - l_hrch21,hrch21 = hrch21 - l_hrch21
                      WHERE hrch01 = l_hrch.hrch01
                        AND hrch02 = l_hrch.hrch02
                        AND hrch03 = l_hrch.hrch03                      
                     LET l_hrch21 = 0 
                     LET l_avl_day = l_avl_day - l_hrch20
                  END IF  
                  #调整调
                  IF l_hrch22 >0 AND l_hrch22 >= l_avl_day THEN 
         	           UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch22 = hrch22 - l_avl_day
                      WHERE hrch01 = l_hrch.hrch01
                        AND hrch02 = l_hrch.hrch02
                        AND hrch03 = l_hrch.hrch03
                     LET l_avl_day = 0
                  ELSE 
         	           UPDATE hrch_file SET hrch17 = hrch17 - l_hrch22,hrch22 = hrch22 - l_hrch22
                      WHERE hrch01 = l_hrch.hrch01
                        AND hrch02 = l_hrch.hrch02
                        AND hrch03 = l_hrch.hrch03                      
                     LET l_hrch22 = 0 
                     LET l_avl_day = l_avl_day - l_hrch22
                  END IF
                  IF l_avl_day > 0 THEN  
                 	   SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid = l_hrcda.hrcda04
                     LET l_msg = l_day
                     CALL s_errmsg('hrat01',l_hrat01||l_hrat02,l_msg,'ghr-141',1)
                     LET g_success = 'N'
                     EXIT WHILE  
                  ELSE 
                     EXIT WHILE   
                  END IF                                                          	 
               END WHILE
         END CASE 
         IF l_hrcf.hrcf26 = 'Y' THEN
            CALL g_hrch_1.appendElement()
            LET g_hrch_1[g_hrch_1.getLength()].hrch01 = l_hrch.hrch01
            LET g_hrch_1[g_hrch_1.getLength()].hrch02 = l_hrch.hrch02
            LET g_hrch_1[g_hrch_1.getLength()].hrch03 = l_hrch.hrch03
            LET g_hrch_1[g_hrch_1.getLength()].hrch19 = l_hrch.hrch19
          END IF 
     END FOREACH 
END FUNCTION

FUNCTION sghri044_revoke_p3_chk(l_hrcdb,l_hrch) 
  DEFINE l_hrcdb   RECORD  LIKE hrcdb_file.*
  DEFINE l_hrch    RECORD  LIKE hrch_file.*
  DEFINE l_des     BOOLEAN
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06 
    
    LET l_des = TRUE
    
    CALL sghri044__umf(l_hrcdb.hrcdb04,l_hrcdb.hrcdb05,'001') RETURNING l_umf_day
    CASE l_hrcdb.hrcdb06 
       WHEN '1'
          IF l_hrch.hrch06 >= l_umf_day THEN
          	 LET l_des = TRUE
          ELSE 
             LET l_des = FALSE
          END IF 
       WHEN '2'
          IF l_hrch.hrch17 >= l_umf_day THEN 
          	 LET l_des = TRUE
          ELSE
             LET l_des = FALSE
          END IF 
    END CASE 
    RETURN l_des
END FUNCTION


FUNCTION sghri044_revoke_day4(l_hrcda)
  DEFINE l_n   LIKE  type_file.num10
  DEFINE l_msg STRING
  DEFINE l_hrcda  RECORD  LIKE hrcda_file.*
  DEFINE l_hrcdb  RECORD  LIKE hrcdb_file.*  
  DEFINE l_hrci   RECORD  LIKE hrci_file.*
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06 
  DEFINE l_des    BOOLEAN
  DEFINE l_hrat01  LIKE hrat_file.hrat01
  DEFINE l_hrat02  LIKE hrat_file.hrat02 
        
      LET g_sql = "SELECT hrci_file.*,hrcdb_file.* FROM hrci_file,hrcdb_file ",
                  " WHERE hrci01 = hrcdb03 ",
                  "   AND hrch02 = '",l_hrcda.hrcda04,"' ",
                  "   AND hrcdb01 = '",l_hrcda.hrcda02,"' ",
                  "   AND hrcdb02 = '",l_hrcda.hrcda01,"' "
      PREPARE sghri044_revoke_p4chk_prep FROM g_sql
      DECLARE sghri044_revoke_p4chk_cs CURSOR FOR sghri044_revoke_p4chk_prep
      FOREACH sghri044_revoke_p4chk_cs INTO l_hrci.*,l_hrcdb.*   
         CALL sghri044_revoke_p4_chk(l_hrcdb.*,l_hrci.*) RETURNING l_des
         IF NOT l_des THEN 
            LET g_success = 'N'
            SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid = l_hrcda.hrcda04
            IF g_errshow THEN 
           	   CALL cl_err(l_msg,'ghr-142',1)
            ELSE 
               CALL s_errmsg('hrat01',l_hrat01||l_hrat02,l_msg,'ghr-142',1)
            END IF 
            EXIT FOREACH
         ELSE  
            CALL sghri044__umf(l_hrcdb.hrcdb04,l_hrcdb.hrcdb05,'003') RETURNING l_umf_day                    
            UPDATE hrci_file SET hrci08 = hrci08-l_umf_day ,hrci09 = hrci09+l_umf_day
             WHERE hrci01 = l_hrcdb.hrcdb03
               AND hrci02 = l_hrcda.hrcda04
            IF SQLCA.sqlcode THEN 
               LET g_success = 'N'
               IF g_errshow THEN
                  CALL cl_err('',SQLCA.sqlcode,1)
               ELSE 
                  LET l_msg = 'upd hrcc chk 4.1'
                  CALL s_errmsg('hrcda02',l_hrcda.hrcda02,l_msg,sqlca.sqlcode,1)
               END IF 
            END IF               
         END IF 
      END FOREACH
END FUNCTION

FUNCTION sghri044_revoke_p4_chk(l_hrcdb,l_hrci) 
  DEFINE l_hrcdb   RECORD  LIKE hrcdb_file.*
  DEFINE l_hrci    RECORD  LIKE hrci_file.*
  DEFINE l_des     BOOLEAN
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06 
    
    LET l_des = TRUE
    
    CALL sghri044__umf(l_hrcdb.hrcdb04,l_hrcdb.hrcdb05,'003') RETURNING l_umf_day
    IF l_hrci.hrci09 >= l_umf_day THEN 
    	  LET l_des = TRUE
    ELSE 
        LET l_des = FALSE
    END IF 
    RETURN l_des
END FUNCTION
 #130916 add by wangxh --str--
FUNCTION revoke_ri044cs()

 CALL cl_set_act_visible("accept,cancel",TRUE) 
 INPUT ARRAY l_revoke WITHOUT DEFAULTS FROM s_revoke.*
       ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 

        BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_set_comp_visible("chk",TRUE) #130612 add by wangxh130912
            CALL cl_set_comp_entry("chk",TRUE)
            CALL cl_set_comp_entry("hrcda16,hrcda17,hrcda03b,hrcda03b_name,hrcda02,hrcda01,hrcda04,hrat02,hrat04,hrat17,hrat05,hrcda05b,hrcda06,hrcda07,hrcda08,hrcda09,hrcda10,hrcda15b",FALSE)
            
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
 
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
            
        ON ACTION about     
            CALL cl_about()   
 
        ON ACTION help         
           CALL cl_show_help() 
 
        ON ACTION controls    
           CALL cl_set_head_visible("","AUTO") 
   END INPUT
    CALL cl_set_act_visible("accept,cancel",FALSE) 
   CALL cl_set_comp_visible("chk",FALSE)    #130912 add by wangxh
   CALL cl_set_comp_entry("hrcda16,hrcda17,hrcda03b,hrcda03b_name,hrcda02,hrcda01,hrcda04,hrat02,hrat04,hrat17,hrat05,hrcda05b,hrcda06,hrcda07,hrcda08,hrcda09,hrcda10,hrcda15b",TRUE)
   
   IF INT_FLAG THEN 
      LET INT_FLAG = FALSE
      RETURN
   END IF 
  
END FUNCTION
#130916 add by wangxh --end--
