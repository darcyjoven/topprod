# Prog. Version..: '5.30.04-08.10.22(00000)'     #
#
# Pattern name...: sghri057.4gl
# Descriptions...: 
# Date & Author..: 13/06/08 by yougs
# Modify.........: 13/08/12 By Exia   完成主要处理逻辑,逻辑在点击处理按钮开始运算

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrat        DYNAMIC ARRAY OF RECORD
         sure            LIKE type_file.chr1,      
         hrat01          LIKE hrat_file.hrat01,     
         hrat02          LIKE hrat_file.hrat02,     
         hrat04          LIKE hrat_file.hrat04,     
         hrao02          LIKE hrao_file.hrao02,     
         hrat05          LIKE hrat_file.hrat05,     
         hras04          LIKE hras_file.hras04,     
         hrat25          LIKE hrat_file.hrat25,     
         hrat19          LIKE hrat_file.hrat19,     
         hrat19_name     LIKE hrad_file.hrad03
                     END RECORD,
    g_hrat_t         RECORD                 
         sure            LIKE type_file.chr1,      
         hrat01          LIKE hrat_file.hrat01,     
         hrat02          LIKE hrat_file.hrat02,     
         hrat04          LIKE hrat_file.hrat04,     
         hrao02          LIKE hrao_file.hrao02,     
         hrat05          LIKE hrat_file.hrat05,     
         hras04          LIKE hras_file.hras04,     
         hrat25          LIKE hrat_file.hrat25,     
         hrat19          LIKE hrat_file.hrat19,     
         hrat19_name     LIKE hrad_file.hrad03
                     END RECORD
DEFINE tm            RECORD 
         b_date          LIKE type_file.dat,
         e_date          LIKE type_file.dat,
         bz              LIKE type_file.chr1000
                     END RECORD
DEFINE gs_cnt        LIKE type_file.num10    
DEFINE ls_ac         LIKE type_file.num10
DEFINE gs_rec_b      LIKE type_file.num10
DEFINE gs_forupd_sql STRING   

FUNCTION i057_auto_generate()
  
   WHENEVER ERROR CALL cl_err_msg_log 

   OPEN WINDOW i057_1_w AT 4,3 WITH FORM "ghr/42f/ghri057_1"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)  
   CALL cl_ui_init()

   #数据单身临时表
   DROP TABLE tmp_hrat 
   CREATE TEMP TABLE tmp_hrat
   ( chk      varchar(1),
     hrat01   varchar(50),
     hratid   varchar(50)
   )
   
   #津贴班次临时表
   DROP TABLE tmp_jtbc
   CREATE TEMP TABLE tmp_jtbc
   ( jtbc01    VARCHAR(20),
     jtbc02    VARCHAR(20)
   )

   #津贴不享受项目临时表
   DROP TABLE tmp_jtxm
   CREATE TEMP TABLE tmp_jtxm
   ( jtxm01    VARCHAR(20),
     jtxm02    VARCHAR(20)
   )
   CALL i057_1_a()
   
   CLOSE WINDOW i057_1_w                 
END FUNCTION 
 
FUNCTION i057_1_a()
DEFINE l_n    LIKE   type_file.num5    
                        
   MESSAGE ""
   CLEAR FORM
   CALL g_hrat.clear()
   INITIALIZE tm.* TO NULL

   CALL cl_opmsg('a')

   WHILE TRUE                     
      LET tm.b_date = g_today
      LET tm.e_date = g_today
      DISPLAY BY NAME tm.b_date,tm.e_date
       
      CALL i057_1_i("a")                       

      IF INT_FLAG THEN            
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      ELSE 
         LET gs_rec_b=0 
         DELETE FROM tmp_hrat
         CALL i057_1_b()   
         IF INT_FLAG THEN 
            LET INT_FLAG=0
            CALL cl_err('',9001,0)
            EXIT WHILE
         ELSE
            DELETE FROM tmp_jtbc
            DELETE FROM tmp_jtxm
            CALL i057_1_inshrcq()
         END IF 
      END IF 
      EXIT WHILE
   END WHILE
           
END FUNCTION 
 
FUNCTION i057_1_i(p_cmd)                       
DEFINE p_cmd        LIKE type_file.chr1    

   CALL cl_set_head_visible("","YES")   

   INPUT BY NAME tm.b_date,tm.e_date,tm.bz  WITHOUT DEFAULTS 

      AFTER FIELD b_date 
          IF NOT cl_null(tm.b_date) AND NOT cl_null(tm.e_date) THEN
             IF tm.b_date>tm.e_date THEN
                CALL cl_err("开始日期不能大于结束日期",'!',0)
                NEXT FIELD b_date
             END IF
          END IF  
     
      AFTER FIELD e_date 
          IF NOT cl_null(tm.b_date) AND NOT cl_null(tm.e_date) THEN
             IF tm.b_date>tm.e_date THEN
                CALL cl_err("结束日期不能小于开始日期",'!',0)
                NEXT FIELD e_date
             END IF
          END IF    
                     
      AFTER INPUT 
         IF INT_FLAG THEN
            RETURN
         END IF 
                 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about
         CALL cl_about()
      
      ON ACTION help
         CALL cl_show_help()
      
      ON ACTION controlg
         CALL cl_cmdask() 
      
   END INPUT
END FUNCTION   
 
FUNCTION i057_1_b()
DEFINE l_sql        STRING
DEFINE l_wc1        STRING
DEFINE l_wc2        STRING
DEFINE l_wc3        STRING
DEFINE l_wc4        STRING
DEFINE l_n             LIKE type_file.num5                 
DEFINE l_lock_sw       LIKE type_file.chr1                 
DEFINE p_cmd           LIKE type_file.chr1
DEFINE l_hratid        LIKE hrat_file.hratid


   IF s_shut(0) THEN 
      RETURN 
   END IF

   LET gs_forupd_sql = "SELECT chk,hrat01 FROM tmp_hrat WHERE hrat01=? FOR UPDATE "
   LET gs_forupd_sql = cl_forupd_sql(gs_forupd_sql)
   DECLARE i057_1_bcl CURSOR FROM gs_forupd_sql
   
   INPUT ARRAY g_hrat WITHOUT DEFAULTS FROM s_hrat.*
         ATTRIBUTE (COUNT=gs_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = TRUE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
 
      BEFORE INPUT
         IF gs_rec_b != 0 THEN
            CALL fgl_set_arr_curr(ls_ac)
         END IF  
       
      BEFORE ROW
         LET p_cmd='' 
         LET ls_ac = ARR_CURR()
         LET l_lock_sw = 'N'       
         LET l_n  = ARR_COUNT()
 
         IF gs_rec_b>=ls_ac THEN
            BEGIN WORK
            LET p_cmd='u'    
            LET g_hrat_t.* = g_hrat[ls_ac].* 
            OPEN i057_1_bcl USING g_hrat_t.hrat01
            IF STATUS THEN
               CALL cl_err("OPEN i057_1_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i057_1_bcl INTO g_hrat[ls_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrat_t.hrat01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            SELECT hrat02,hrat04,hrat05,hrat25,hrat19 INTO g_hrat[ls_ac].hrat02,g_hrat[ls_ac].hrat04,g_hrat[ls_ac].hrat05,g_hrat[ls_ac].hrat25,g_hrat[ls_ac].hrat19
              FROM hrat_file
             WHERE hrat01 = g_hrat[ls_ac].hrat01
               AND hratconf = 'Y'
            SELECT hrao02 INTO g_hrat[ls_ac].hrao02 FROM hrao_file WHERE hrao01 = g_hrat[ls_ac].hrat04        
            SELECT hrap06 INTO g_hrat[ls_ac].hras04 FROM hrap_file WHERE hrap05 = g_hrat[ls_ac].hrat05 AND hrap01 = g_hrat[ls_ac].hrat04 
            SELECT hrad03 INTO g_hrat[ls_ac].hrat19_name FROM hrad_file WHERE hrad02 = g_hrat[ls_ac].hrat19 AND rownum = 1
            CALL cl_show_fld_cont()    
            CALL i057_1_b_set_entry(p_cmd)
         END IF 
        
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a' 
         INITIALIZE g_hrat[ls_ac].* TO NULL                   
         LET g_hrat[ls_ac].sure = 'Y'                     
         CALL cl_show_fld_cont()     
         CALL i057_1_b_set_entry(p_cmd)
        
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i057_1_bcl
            CANCEL INSERT
         END IF

         IF NOT cl_null(g_hrat[ls_ac].hrat01) THEN
            SELECT hratid INTO l_hratid FROM hrat_file
             WHERE hrat01 = g_hrat[ls_ac].hrat01
            INSERT INTO tmp_hrat VALUES(g_hrat[ls_ac].sure,g_hrat[ls_ac].hrat01,l_hratid)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","tmp_hrat",g_hrat[ls_ac].hrat01,"",SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL INSERT
            ELSE  
               LET gs_rec_b=gs_rec_b+1    
               DISPLAY gs_rec_b TO FORMONLY.cn22     
               COMMIT WORK  
            END IF            
         END IF
        
      AFTER FIELD hrat01                       
         IF NOT cl_null(g_hrat[ls_ac].hrat01) AND ((p_cmd = 'a') OR (p_cmd='u' AND g_hrat[ls_ac].hrat01 <> g_hrat_t.hrat01)) THEN  
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM tmp_hrat
             WHERE hrat01 = g_hrat[ls_ac].hrat01
            IF l_n > 0 THEN 
              CALL cl_err('员工资料已经有了','!',0)
              NEXT FIELD hrat01                                
            END IF  
            #   add by wangyuz 171013     # 可以下*处理全部员工数据
            IF g_hrat[ls_ac].hrat01 ="*"  THEN 
               LET l_sql = "INSERT INTO tmp_hrat SELECT 'Y',hrat01,hratid ",
                           "  FROM hrat_file WHERE hrat01 NOT IN(SELECT hrat01 FROM tmp_hrat) AND hratconf = 'Y'  AND hrat19 not like '3%'" 
                PREPARE hrat01_pre1  FROM l_sql
                EXECUTE hrat01_pre1
               
              LET l_sql= " SELECT hrat01,hrat02,hrat04,hrat05,hrat25,hrat19 ",
                              " FROM hrat_file  ",
                              " WHERE hratconf = 'Y'   AND hrat19 NOT LIKE '3%' "    
               PREPARE i057_1_pb1 FROM l_sql
               DECLARE hrat_1_curs1 CURSOR FOR i057_1_pb1 
               FOREACH  hrat_1_curs1   INTO g_hrat[ls_ac].hrat01,g_hrat[ls_ac].hrat02,g_hrat[ls_ac].hrat04,g_hrat[ls_ac].hrat05,g_hrat[ls_ac].hrat25,g_hrat[ls_ac].hrat19             
                  SELECT hrao02 INTO g_hrat[ls_ac].hrao02 FROM hrao_file WHERE hrao01 = g_hrat[ls_ac].hrat04
                  SELECT hrap06 INTO g_hrat[ls_ac].hras04 FROM hrap_file WHERE hrap05 = g_hrat[ls_ac].hrat05 AND hrap01 = g_hrat[ls_ac].hrat04
                  SELECT hrad03 INTO g_hrat[ls_ac].hrat19_name FROM hrad_file WHERE hrad02 = g_hrat[ls_ac].hrat19 AND rownum = 1       
                    LET ls_ac =ls_ac +1 
                  DISPLAY BY NAME g_hrat[ls_ac].hrat01,g_hrat[ls_ac].hrao02,g_hrat[ls_ac].hras04,g_hrat[ls_ac].hrat19_name,g_hrat[ls_ac].hrat02,g_hrat[ls_ac].hrat04,g_hrat[ls_ac].hrat05,g_hrat[ls_ac].hrat25,g_hrat[ls_ac].hrat19   
               END FOREACH  
            #add by wangyuz 171013  end 
            ELSE 
               SELECT hrat02,hrat04,hrat05,hrat25,hrat19 INTO  g_hrat[ls_ac].hrat01 ,g_hrat[ls_ac].hrat02,g_hrat[ls_ac].hrat04,g_hrat[ls_ac].hrat05,g_hrat[ls_ac].hrat25,g_hrat[ls_ac].hrat19
               FROM hrat_file
                WHERE     hrat01 = g_hrat[ls_ac].hrat01  AND    hratconf = 'Y'
                     
               IF STATUS THEN
                  CALL cl_err("无此员工编号",'!',0)
                  NEXT FIELD hrat01                    
               END IF
               DISPLAY BY NAME  g_hrat[ls_ac].hrat02,g_hrat[ls_ac].hrat04,g_hrat[ls_ac].hrat05,g_hrat[ls_ac].hrat25,g_hrat[ls_ac].hrat19   
            END IF     #add by wangyuz 171013  
         END IF
         
      ON ROW CHANGE
         IF INT_FLAG THEN             
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrat[ls_ac].* = g_hrat_t.*
            CLOSE i057_1_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_hrat[ls_ac].hrat01,-263,0)
            LET g_hrat[ls_ac].* = g_hrat_t.*
         ELSE 
            SELECT hratid INTO l_hratid FROM hrat_file
             WHERE hrat01 = g_hrat[ls_ac].hrat01
            UPDATE tmp_hrat SET chk = g_hrat[ls_ac].sure,
                                hrat01 = g_hrat[ls_ac].hrat01,
                                hratid = l_hratid
                          WHERE hrat01 = g_hrat_t.hrat01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tmp_hrat",g_hrat[ls_ac].hrat01,'',SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK     
               LET g_hrat[ls_ac].* = g_hrat_t.*
            END IF
         END IF   
        
                    
      AFTER ROW
         LET ls_ac = ARR_CURR()               
      
         IF INT_FLAG THEN       
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_hrat[ls_ac].* = g_hrat_t.*
            END IF
            CLOSE i057_1_bcl                
            ROLLBACK WORK                 
            EXIT INPUT
         END IF
         CLOSE i057_1_bcl                
         COMMIT WORK      
        
        
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrat01)
               IF p_cmd = 'a' THEN 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_hrat01"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.where = "hratconf = 'Y' "
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING l_wc1
                  IF l_wc1 = " 1=1" THEN
                     LET l_wc1 = " 1=0"
                  ELSE
                  #add by wangyuz 171013 str 
                     IF l_wc1.getlength()> 1000 THEN     #如果开窗全选，l_wc1会变得超长，sql表达式不支持超过1000的，当开窗数据大于1000时，默认全选   排除离职员工  
                        LET l_sql = "INSERT INTO tmp_hrat SELECT 'Y',hrat01,hratid ",
                                    "  FROM hrat_file WHERE hrat01 NOT IN(SELECT hrat01 FROM tmp_hrat) AND hratconf = 'Y'  AND hrat19 not like '3%'"
                     ELSE 
                  #add by wangyuz 171013 end 
                     LET l_wc1 = cl_replace_str(l_wc1,"|","','")
                     LET l_wc1 = "('",l_wc1,"')"
                     LET l_wc1 = "hrat01 IN ",l_wc1
                     LET l_sql = "INSERT INTO tmp_hrat SELECT 'Y',hrat01,hratid ",
                                 "  FROM hrat_file WHERE hrat01 NOT IN(SELECT hrat01 FROM tmp_hrat) AND hratconf = 'Y' AND ",l_wc1
                     END IF 
                     PREPARE hrat01_pre  FROM l_sql
                     EXECUTE hrat01_pre
                     
                     CALL i057_1_b_fill()
                     CALL i057_1_b()
                     EXIT INPUT
                  END IF
               ELSE   
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrat01"
                  LET g_qryparam.default1 = g_hrat[ls_ac].hrat01
                  CALL cl_create_qry() RETURNING g_hrat[ls_ac].hrat01
                  DISPLAY BY NAME g_hrat[ls_ac].hrat01
                  NEXT FIELD hrat01
               END IF
            WHEN INFIELD(hrat04)
               IF p_cmd = 'a' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_hrao01"
                  LET g_qryparam.construct = 'N' 
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING l_wc2
                  IF l_wc2 = " 1=1" THEN
                     LET l_wc2 = " 1=0"
                  ELSE
                     LET l_wc2 = cl_replace_str(l_wc2,"|","','")
                     LET l_wc2 = "('",l_wc2,"')"
                     LET l_wc2 = "hrat04 IN ",l_wc2
                     LET l_sql = "INSERT INTO tmp_hrat SELECT 'Y',hrat01,hratid ",
                                 "  FROM hrat_file WHERE hrat01 NOT IN(SELECT hrat01 FROM tmp_hrat) AND hratconf = 'Y' AND ",l_wc2
                     PREPARE hrat04_pre  FROM l_sql
                     EXECUTE hrat04_pre
                     CALL i057_1_b_fill()
                     CALL i057_1_b()
                     EXIT INPUT
                  END IF
               ELSE    
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrao01"
                  LET g_qryparam.default1 = g_hrat[ls_ac].hrat04
                  CALL cl_create_qry() RETURNING g_hrat[ls_ac].hrat04
                  DISPLAY BY NAME g_hrat[ls_ac].hrat04
                  NEXT FIELD hrat04
               END IF
            WHEN INFIELD(hrat05)
               IF p_cmd = 'a' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_hrap01"
                  LET g_qryparam.construct = 'N' 
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING l_wc3
                  IF l_wc3 = " 1=1" THEN
                     LET l_wc3 = " 1=0"
                  ELSE
                     LET l_wc3 = cl_replace_str(l_wc3,"|","','")
                     LET l_wc3 = "('",l_wc3,"')"
                     LET l_wc3 = "hrat05 IN ",l_wc3
                     LET l_sql = "INSERT INTO tmp_hrat SELECT 'Y',hrat01,hratid ", 
                                 "  FROM hrat_file WHERE hrat01 NOT IN(SELECT hrat01 FROM tmp_hrat) AND hratconf = 'Y' AND ",l_wc3
                     PREPARE hrat05_pre  FROM l_sql
                     EXECUTE hrat05_pre
                     CALL i057_1_b_fill()
                     CALL i057_1_b()
                     EXIT INPUT
                  END IF
               ELSE    
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrap01"
                  LET g_qryparam.default1 = g_hrat[ls_ac].hrat05
                  CALL cl_create_qry() RETURNING g_hrat[ls_ac].hrat05
                  DISPLAY BY NAME g_hrat[ls_ac].hrat05
                  NEXT FIELD hrat05
               END IF
            WHEN INFIELD(hrat19)
               IF p_cmd = 'a' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_hrad02"
                  LET g_qryparam.construct = 'N' 
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING l_wc4
                  IF l_wc4 = " 1=1" THEN
                     LET l_wc4 = " 1=0"
                  ELSE
                     LET l_wc4 = cl_replace_str(l_wc4,"|","','")
                     LET l_wc4 = "('",l_wc4,"')"
                     LET l_wc4 = "hrat19 IN ",l_wc4
                     LET l_sql = "INSERT INTO tmp_hrat SELECT 'Y',hrat01,hratid ",
                                 "  FROM hrat_file WHERE hrat01 NOT IN(SELECT hrat01 FROM tmp_hrat) AND hratconf = 'Y' AND ",l_wc4
                     PREPARE hrat19_pre  FROM l_sql
                     EXECUTE hrat19_pre
                     CALL i057_1_b_fill()
                     CALL i057_1_b()
                     EXIT INPUT
                  END IF
               ELSE    
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrad02"
                  LET g_qryparam.default1 = g_hrat[ls_ac].hrat19
                  CALL cl_create_qry() RETURNING g_hrat[ls_ac].hrat19
                  DISPLAY BY NAME g_hrat[ls_ac].hrat19
                  NEXT FIELD hrat19
               END IF
         END CASE
                 
      ON ACTION CONTROLG
         CALL cl_cmdask()
     
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
     
      ON ACTION about                      
         CALL cl_about()                   
                                           
      ON ACTION help                       
         CALL cl_show_help()               
     
   END INPUT   
   CLOSE i057_1_bcl
   COMMIT WORK 
END FUNCTION 

FUNCTION i057_1_b_set_entry(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a' THEN
      CALL cl_set_comp_entry("hrat04,hrat05,hrat19",TRUE)   
   ELSE
      CALL cl_set_comp_entry("hrat04,hrat05,hrat19",FALSE)
   END IF 
END FUNCTION 

FUNCTION i057_1_b_fill()
DEFINE l_sql     STRING

   LET l_sql = "SELECT chk,hrat01,'','','','','','','','' ",
               " FROM tmp_hrat ", 
               " ORDER BY hrat01"

   PREPARE i057_1_pb FROM l_sql
   DECLARE hrat_1_curs CURSOR FOR i057_1_pb

   CALL g_hrat.clear()

   LET gs_cnt = 1

   FOREACH hrat_1_curs INTO g_hrat[gs_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      SELECT hrat02,hrat04,hrat05,hrat25,hrat19 INTO g_hrat[gs_cnt].hrat02,g_hrat[gs_cnt].hrat04,g_hrat[gs_cnt].hrat05,g_hrat[gs_cnt].hrat25,g_hrat[gs_cnt].hrat19
        FROM hrat_file
       WHERE hrat01 = g_hrat[gs_cnt].hrat01
         AND hratconf = 'Y'
      SELECT hrao02 INTO g_hrat[gs_cnt].hrao02 FROM hrao_file WHERE hrao01 = g_hrat[gs_cnt].hrat04
      SELECT hrap06 INTO g_hrat[gs_cnt].hras04 FROM hrap_file WHERE hrap05 = g_hrat[gs_cnt].hrat05 AND hrap01 = g_hrat[gs_cnt].hrat04
      SELECT hrad03 INTO g_hrat[gs_cnt].hrat19_name FROM hrad_file WHERE hrad02 = g_hrat[gs_cnt].hrat19 AND rownum = 1       
      LET gs_cnt = gs_cnt + 1 
   END FOREACH

   CALL g_hrat.deleteElement(gs_cnt)
   MESSAGE ""
   LET gs_rec_b = gs_cnt-1
   DISPLAY gs_rec_b TO FORMONLY.cn22 

END FUNCTION

FUNCTION i057_1_inshrcq()
DEFINE l_hrcq      RECORD LIKE hrcq_file.*
DEFINE l_hrbm      RECORD LIKE hrbm_file.*
DEFINE tok         base.StringTokenizer
DEFINE l_sql       STRING
DEFINE l_hrbm03    LIKE hrbm_file.hrbm03   
DEFINE l_hrbm15    LIKE hrbm_file.hrbm15   
DEFINE l_hrbm16    LIKE hrbm_file.hrbm16
DEFINE l_str       LIKE hrbm_file.hrbm03
DEFINE l_count     LIKE type_file.num5
DEFINE l_jtbc01    LIKE hrbm_file.hrbm03
DEFINE l_date      LIKE type_file.num10
DEFINE l_hrcp03    LIKE hrcp_file.hrcp03
DEFINE l_hrcp      RECORD LIKE hrcp_file.* 

   SELECT MAX(hrcq01) INTO l_hrcq.hrcq01 FROM hrcq_file 
   IF cl_null(l_hrcq.hrcq01) THEN LET l_hrcq.hrcq01=0 END IF 
   
   #解析津贴数据 
   LET l_sql = "SELECT hrbm03,hrbm15,hrbm16 FROM hrbm_file WHERE hrbm02 = '007' AND hrbm07 = 'Y' "

   PREPARE sel_hrbm_pre FROM l_sql
   DECLARE sel_hrbm_cs CURSOR FOR sel_hrbm_pre
  
   FOREACH sel_hrbm_cs INTO l_hrbm03,l_hrbm15,l_hrbm16
      LET tok = base.StringTokenizer.create(l_hrbm15,"|")
      IF NOT cl_null(l_hrbm15) THEN
         WHILE tok.hasMoreTokens()
            LET l_str=tok.nextToken()
            INSERT INTO tmp_jtbc VALUES(l_hrbm03,l_str)
         END WHILE
      END IF
      
      LET tok = base.StringTokenizer.create(l_hrbm16,"|")
      IF NOT cl_null(l_hrbm16) THEN
         WHILE tok.hasMoreTokens()
            LET l_str=tok.nextToken()
            INSERT INTO tmp_jtxm VALUES(l_hrbm03,l_str)
         END WHILE
      END IF 
   END FOREACH
      
   FOR l_date=tm.b_date TO tm.e_date
       LET l_hrcp03=l_date 
       
       #获取员工考勤数据
       LET l_sql = "SELECT hrcp_file.* FROM hrcp_file,tmp_hrat",
#                   " WHERE hrcp02 = hratid AND hrcp03='",l_hrcp03,"' AND hrcp35 ='Y' AND hrcp04 IN (SELECT jtbc02 FROM tmp_jtbc) "   #mark by wangyuz 171013   hrcp35在画面上被隐藏
                    " WHERE hrcp02 = hratid AND hrcp03='",l_hrcp03,"'  AND hrcp04 IN (SELECT jtbc02 FROM tmp_jtbc) "    #add by wangyuz 171013
       PREPARE sel_hrcp_pre FROM l_sql
       DECLARE sel_hrcp_cs CURSOR FOR sel_hrcp_pre
       FOREACH sel_hrcp_cs INTO l_hrcp.*

         #获取享受的津贴
         LET l_sql = "SELECT jtbc01 FROM tmp_jtbc WHERE jtbc02 = '",l_hrcp.hrcp04,"' "
         PREPARE sel_jtbc_pre FROM l_sql
         DECLARE sel_jtbc_cs CURSOR FOR sel_jtbc_pre
         FOREACH sel_jtbc_cs INTO l_jtbc01

         #检查员工是否存在不享受津贴的情况
         LET l_count=0
         SELECT count(*) FROM hrcq_file 
          WHERE hrcq02=l_hrcp.hrcp02 AND hrcq03=l_hrcp03 AND hrcq05=l_jtbc01 AND (hrcq08='Y' OR hrcqconf='Y')
         IF l_count>0 THEN 
            CONTINUE FOREACH
         END IF 

         LET l_count=0 
         SELECT count(*) INTO l_count FROM hrcq_file
          WHERE hrcq02=l_hrcp.hrcp02 AND hrcq03=l_hrcp03 AND hrcq05=l_jtbc01 AND hrcq08='N' AND hrcqconf='N'
         IF l_count>0 THEN 
            DELETE FROM hrcq_file
             WHERE hrcq02=l_hrcp.hrcp02 AND hrcq03=l_hrcp03 AND hrcq05=l_jtbc01 
         END IF 
         
         IF NOT cl_null(l_hrcp.hrcp10) THEN
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM tmp_jtxm WHERE jtxm01 = l_jtbc01 AND jtxm02 = l_hrcp.hrcp10 
            IF cl_null(l_count) THEN LET l_count = 0 END IF 
            IF l_count > 0 THEN
               CONTINUE FOREACH 
            END IF
         END IF

         IF NOT cl_null(l_hrcp.hrcp12) THEN
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM tmp_jtxm WHERE jtxm01 = l_jtbc01 AND jtxm02 = l_hrcp.hrcp12
            IF cl_null(l_count) THEN LET l_count = 0 END IF
            IF l_count > 0 THEN
               CONTINUE FOREACH
            END IF
         END IF

         IF NOT cl_null(l_hrcp.hrcp14) THEN
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM tmp_jtxm WHERE jtxm01 = l_jtbc01 AND jtxm02 = l_hrcp.hrcp14
            IF cl_null(l_count) THEN LET l_count = 0 END IF
            IF l_count > 0 THEN
               CONTINUE FOREACH
            END IF
         END IF

         IF NOT cl_null(l_hrcp.hrcp16) THEN
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM tmp_jtxm WHERE jtxm01 = l_jtbc01 AND jtxm02 = l_hrcp.hrcp16
            IF cl_null(l_count) THEN LET l_count = 0 END IF
            IF l_count > 0 THEN
               CONTINUE FOREACH
            END IF
         END IF

         IF NOT cl_null(l_hrcp.hrcp18) THEN
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM tmp_jtxm WHERE jtxm01 = l_jtbc01 AND jtxm02 = l_hrcp.hrcp18
            IF cl_null(l_count) THEN LET l_count = 0 END IF
            IF l_count > 0 THEN
               CONTINUE FOREACH
            END IF
         END IF

         IF NOT cl_null(l_hrcp.hrcp20) THEN
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM tmp_jtxm WHERE jtxm01 = l_jtbc01 AND jtxm02 = l_hrcp.hrcp20
            IF cl_null(l_count) THEN LET l_count = 0 END IF
            IF l_count > 0 THEN
               CONTINUE FOREACH
            END IF
         END IF    
         
         #计算津贴时长 
         SELECT * INTO l_hrbm.* FROM hrbm_file WHERE hrbm03=l_jtbc01
         CALL i057_1_hrcp(l_hrbm.*,l_hrcp.*) RETURNING l_hrcq.hrcq06
         IF l_hrcq.hrcq06=0 THEN 
            CONTINUE FOREACH
         END IF 
         
         #插入数据
         LET l_hrcq.hrcq01=l_hrcq.hrcq01+1
         LET l_hrcq.hrcq02=l_hrcp.hrcp02
         LET l_hrcq.hrcq03=l_hrcp03
         LET l_hrcq.hrcq04=l_hrcp.hrcp04
         LET l_hrcq.hrcq05=l_jtbc01
         LET l_hrcq.hrcq07=tm.bz
         LET l_hrcq.hrcq08='N'
         LET l_hrcq.hrcqconf='N'
         LET l_hrcq.hrcqacti='Y'
         LET l_hrcq.hrcquser=g_user
         LET l_hrcq.hrcqgrup=g_grup
         LET l_hrcq.hrcqoriu=g_user
         LET l_hrcq.hrcqorig=g_grup
         LET l_hrcq.hrcqmodu=g_user
         LET l_hrcq.hrcqdate=g_today
         
         INSERT INTO hrcq_file VALUES (l_hrcq.*)
         END FOREACH  
       END FOREACH 
   END FOR   
END FUNCTION 

FUNCTION i057_1_hrcp(p_hrbm,p_hrcp)
DEFINE p_hrbm    RECORD LIKE hrbm_file.*
DEFINE p_hrcp    RECORD LIKE hrcp_file.*
DEFINE p_hrcq06  LIKE type_file.num5
DEFINE l_hrcn04  LIKE hrcn_file.hrcn04
DEFINE l_hrcn05  LIKE type_file.num5
DEFINE l_hrcn06  LIKE hrcn_file.hrcn06
DEFINE l_hrcn07  LIKE type_file.num5
DEFINE l_hrcn08  LIKE hrcn_file.hrcn08
DEFINE l_sql     STRING
DEFINE l_hrbm17  LIKE type_file.num5
DEFINE l_hrcp22  LIKE type_file.num5
DEFINE l_hrcp23  LIKE type_file.num5
DEFINE l_hrcp24  LIKE type_file.num5
DEFINE l_hrcp25  LIKE type_file.num5
DEFINE l_hrcp26  LIKE type_file.num5
DEFINE l_hrcp27  LIKE type_file.num5
DEFINE l_hrcp28  LIKE type_file.num5
DEFINE l_hrcp29  LIKE type_file.num5
DEFINE l_hrcp30  LIKE type_file.num5
DEFINE l_hrcp31  LIKE type_file.num5
DEFINE l_hrcp32  LIKE type_file.num5
DEFINE l_hrcp33  LIKE type_file.num5
DEFINE l_num1    LIKE type_file.num5
DEFINE l_num2    LIKE type_file.num5
DEFINE l_num3    LIKE type_file.num5
DEFINE l_num4    LIKE type_file.num5
DEFINE l_num5    LIKE type_file.num5
DEFINE l_num6    LIKE type_file.num5
DEFINE l_num7    LIKE type_file.num5
DEFINE l_num8    LIKE type_file.num5
DEFINE l_num9    LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5
DEFINE tok       base.StringTokenizer
DEFINE l_hrcp06  LIKE hrcp_file.hrcp06
DEFINE l_hrcp061 LIKE type_file.num5
DEFINE l_hrcp062 LIKE type_file.num5
DEFINE l_type    LIKE type_file.chr1

       LET l_num1=0   
       LET l_num2=0   
       LET l_num3=0
       LET l_num4=0
       LET l_num5=0
       LET l_num6=0
       LET l_num7=0
       LET l_num8=0
       LET l_num9=0
       LET l_type='N'
       LET l_hrbm17=p_hrbm.hrbm17[1,2]*60 + p_hrbm.hrbm17[4,5]
       #加班时段
       LET l_sql=" SELECT hrcn04,(substr(hrcn05,1,2)*60+substr(hrcn05,4,5)),hrcn06,",
                 " (substr(hrcn07,1,2)*60+substr(hrcn07,4,5)),hrcn08 FROM hrcn_file",
                 "  WHERE hrcn03='",p_hrcp.hrcp02,"' AND hrcn14='",p_hrcp.hrcp03,"'",
                 "    AND hrcnconf='Y'"
       PREPARE get_hrcn_p FROM l_sql
       DECLARE get_hrcn_c CURSOR FOR get_hrcn_p
       FOREACH get_hrcn_c INTO l_hrcn04,l_hrcn05,l_hrcn06,l_hrcn07,l_hrcn08
          LET l_num1=l_num1+l_hrcn08
          IF l_hrcn04=l_hrcn06 THEN 
             IF l_hrbm17<l_hrcn05 THEN 
                LET l_num2=l_num2+l_hrcn07-l_hrcn05
                CONTINUE FOREACH 
             END IF 
             IF l_hrbm17>l_hrcn07 THEN
                CONTINUE FOREACH 
             END IF 
             IF l_hrbm17>=l_hrcn05 AND l_hrbm17<=l_hrcn07 THEN 
                LET l_num3=l_num3+l_hrcn07-l_hrbm17
             END IF
          ELSE
             LET l_n=l_hrcn06-l_hrcn04
             LET l_hrcn07=l_n*24*60+l_hrcn07
             IF l_hrbm17<l_hrcn05 THEN
                LET l_hrbm17=l_hrbm17+24*60
                IF l_hrbm17>l_hrcn07 THEN
                   LET l_num2=l_num2+l_hrcn07-l_hrcn05
                   CONTINUE FOREACH 
                ELSE
                   LET l_num3=l_num3+l_hrcn07-l_hrbm17
                END IF 
             ELSE
                LET l_num3=l_num3+l_hrcn07-l_hrbm17
             END IF 
          END IF 
       END FOREACH

       #补充时间
       IF NOT cl_null(p_hrcp.hrcp06) THEN 
       LET tok = base.StringTokenizer.create(p_hrcp.hrcp06,"|")
         WHILE tok.hasMoreTokens()
            LET l_hrcp06=tok.nextToken()
            LET l_hrcp061=l_hrcp06[1,2]*60 + l_hrcp06[4,5]
            LET l_hrcp062=l_hrcp06[7,8]*60 + l_hrcp06[10,11]
            LET l_num4=l_num4+l_hrcp062-l_hrcp061
            IF l_hrbm17<l_hrcp061 THEN 
               LET l_num5=l_num5+l_hrcp062-l_hrcp061 
            END IF 
            IF l_hrbm17>=l_hrcp061 AND l_hrbm17<=l_hrcp062 THEN 
               LET l_num6=l_num6+l_hrcp062-l_hrbm17
            END IF 
         END WHILE
       END IF
       
       #正常时段
       IF NOT cl_null(p_hrcp.hrcp22) AND NOT cl_null(p_hrcp.hrcp23) THEN 
          LET l_hrcp22=p_hrcp.hrcp22[1,2]*60 + p_hrcp.hrcp22[4,5]
          LET l_hrcp23=p_hrcp.hrcp23[1,2]*60 + p_hrcp.hrcp23[4,5]
          IF l_hrcp23<l_hrcp22 THEN 
             LET l_hrcp23=l_hrcp23+24*60
             LET l_type='Y'
          END IF
          LET l_num7=l_num7+l_hrcp23-l_hrcp22
          IF l_hrbm17<l_hrcp22 THEN 
             LET l_hrbm17=l_hrbm17+24*60
             IF l_hrbm17>l_hrcp23 THEN 
                LET l_num8=l_num8+l_hrcp23-l_hrcp22
             ELSE
                LET l_num9=l_num9+l_hrcp23-l_hrbm17
             END IF 
          END IF 
          IF l_hrbm17>=l_hrcp22 AND l_hrbm17<=l_hrcp23 THEN
             LET l_num9=l_num9+l_hrcp23-l_hrbm17
          END IF 
       END IF 
       IF NOT cl_null(p_hrcp.hrcp24) AND NOT cl_null(p_hrcp.hrcp25) THEN 
          LET l_hrcp24=p_hrcp.hrcp24[1,2]*60 + p_hrcp.hrcp24[4,5]
          LET l_hrcp25=p_hrcp.hrcp25[1,2]*60 + p_hrcp.hrcp25[4,5]
          IF l_type='Y' THEN 
             LET l_hrcp24=l_hrcp24+24*60
             LET l_hrcp25=l_hrcp25+24*60
          END IF 
          IF l_hrcp25<l_hrcp24 THEN 
             LET l_hrcp25=l_hrcp25+24*60
             LET l_type='Y'
          END IF
          LET l_num7=l_num7+l_hrcp25-l_hrcp24
          IF l_hrbm17<l_hrcp24 THEN 
             LET l_hrbm17=l_hrbm17+24*60
             IF l_hrbm17>l_hrcp25 THEN 
                LET l_num8=l_num8+l_hrcp25-l_hrcp24
             ELSE
                LET l_num9=l_num9+l_hrcp25-l_hrbm17
             END IF 
          END IF 
          IF l_hrbm17>=l_hrcp24 AND l_hrbm17<=l_hrcp25 THEN 
             LET l_num9=l_num9+l_hrcp25-l_hrbm17
          END IF 
       END IF 
       IF NOT cl_null(p_hrcp.hrcp26) AND NOT cl_null(p_hrcp.hrcp27) THEN 
          LET l_hrcp26=p_hrcp.hrcp26[1,2]*60 + p_hrcp.hrcp26[4,5]
          LET l_hrcp27=p_hrcp.hrcp27[1,2]*60 + p_hrcp.hrcp27[4,5]
          IF l_type='Y' THEN 
             LET l_hrcp26=l_hrcp26+24*60
             LET l_hrcp27=l_hrcp27+24*60
          END IF 
          IF l_hrcp27<l_hrcp26 THEN 
             LET l_hrcp27=l_hrcp27+24*60
             LET l_type='Y'
          END IF
          LET l_num7=l_num7+l_hrcp27-l_hrcp26
          IF l_hrbm17<l_hrcp26 THEN 
             LET l_hrbm17=l_hrbm17+24*60
             IF l_hrbm17>l_hrcp27 THEN 
                LET l_num8=l_num8+l_hrcp27-l_hrcp26
             ELSE
                LET l_num9=l_num9+l_hrcp27-l_hrbm17
             END IF 
          END IF 
          IF l_hrbm17>=l_hrcp26 AND l_hrbm17<=l_hrcp27 THEN
             LET l_num9=l_num9+l_hrcp27-l_hrbm17
          END IF 
       END IF 
       IF NOT cl_null(p_hrcp.hrcp28) AND NOT cl_null(p_hrcp.hrcp29) THEN 
          LET l_hrcp28=p_hrcp.hrcp28[1,2]*60 + p_hrcp.hrcp28[4,5]
          LET l_hrcp29=p_hrcp.hrcp29[1,2]*60 + p_hrcp.hrcp29[4,5]
          IF l_type='Y' THEN 
             LET l_hrcp28=l_hrcp28+24*60
             LET l_hrcp29=l_hrcp29+24*60
          END IF 
          IF l_hrcp29<l_hrcp28 THEN 
             LET l_hrcp29=l_hrcp29+24*60
             LET l_type='Y'
          END IF
          LET l_num7=l_num7+l_hrcp29-l_hrcp28
          IF l_hrbm17<l_hrcp28 THEN 
             LET l_hrbm17=l_hrbm17+24*60
             IF l_hrbm17>l_hrcp29 THEN 
                LET l_num8=l_num8+l_hrcp29-l_hrcp28
             ELSE
                LET l_num9=l_num9+l_hrcp29-l_hrbm17
             END IF 
          END IF 
          IF l_hrbm17>=l_hrcp28 AND l_hrbm17<=l_hrcp29 THEN 
             LET l_num9=l_num9+l_hrcp29-l_hrbm17
          END IF 
       END IF 
       IF NOT cl_null(p_hrcp.hrcp30) AND NOT cl_null(p_hrcp.hrcp31) THEN 
          LET l_hrcp30=p_hrcp.hrcp30[1,2]*60 + p_hrcp.hrcp30[4,5]
          LET l_hrcp31=p_hrcp.hrcp31[1,2]*60 + p_hrcp.hrcp31[4,5]
          IF l_type='Y' THEN 
             LET l_hrcp30=l_hrcp30+24*60
             LET l_hrcp31=l_hrcp31+24*60
          END IF 
          IF l_hrcp31<l_hrcp30 THEN 
             LET l_hrcp31=l_hrcp31+24*60
             LET l_type='Y'
          END IF
          LET l_num7=l_num7+l_hrcp31-l_hrcp30
          IF l_hrbm17<l_hrcp30 THEN 
             LET l_hrbm17=l_hrbm17+24*60
             IF l_hrbm17>l_hrcp31 THEN 
                LET l_num8=l_num8+l_hrcp31-l_hrcp30
             ELSE
                LET l_num9=l_num9+l_hrcp31-l_hrbm17
             END IF 
          END IF  
          IF l_hrbm17>=l_hrcp30 AND l_hrbm17<=l_hrcp31 THEN 
             LET l_num9=l_num9+l_hrcp31-l_hrbm17
          END IF 
       END IF 
       IF NOT cl_null(p_hrcp.hrcp32) AND NOT cl_null(p_hrcp.hrcp33) THEN 
          LET l_hrcp32=p_hrcp.hrcp32[1,2]*60 + p_hrcp.hrcp32[4,5]
          LET l_hrcp33=p_hrcp.hrcp33[1,2]*60 + p_hrcp.hrcp33[4,5]
          IF l_type='Y' THEN 
             LET l_hrcp32=l_hrcp32+24*60
             LET l_hrcp33=l_hrcp33+24*60
          END IF 
          IF l_hrcp33<l_hrcp32 THEN 
             LET l_hrcp33=l_hrcp33+24*60
             LET l_type='Y'
          END IF
          LET l_num7=l_num7+l_hrcp31-l_hrcp30
          IF l_hrbm17<l_hrcp32 THEN 
             LET l_hrbm17=l_hrbm17+24*60
             IF l_hrbm17>l_hrcp33 THEN 
                LET l_num8=l_num8+l_hrcp33-l_hrcp32
             ELSE
                LET l_num9=l_num9+l_hrcp33-l_hrbm17
             END IF 
          END IF  
          IF l_hrbm17>=l_hrcp32 AND l_hrbm17<=l_hrcp33 THEN 
             LET l_num9=l_num9+l_hrcp33-l_hrbm17
          END IF 
       END IF
       
       IF p_hrbm.hrbm34='Y' AND l_num3=0 AND l_num6=0 AND l_num9=0 THEN 
          RETURN 0
       END IF 
       
       IF p_hrbm.hrbm21='Y' THEN 
          IF p_hrbm.hrbm18='Y' THEN 
             LET p_hrcq06=p_hrcq06+l_num5+l_num6+l_num8+l_num9
          END IF 
          IF p_hrbm.hrbm19='Y' THEN 
             LET p_hrcq06=p_hrcq06+l_num2+l_num3
          END IF 
       ELSE
          IF p_hrbm.hrbm18='Y' THEN 
             LET p_hrcq06=p_hrcq06+l_num4+l_num7
          END IF 
          IF p_hrbm.hrbm19='Y' THEN 
             LET p_hrcq06=p_hrcq06+l_num1
          END IF 
       END IF 

       SELECT ceil(p_hrcq06/60) INTO p_hrcq06 FROM dual
    
       IF p_hrcq06<p_hrbm.hrbm22 OR p_hrcq06>p_hrbm.hrbm29 THEN 
          RETURN 0
       END IF 
    
       RETURN p_hrcq06
END FUNCTION 
