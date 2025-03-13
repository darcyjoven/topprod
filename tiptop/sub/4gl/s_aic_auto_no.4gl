# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: s_aic_auto_no.4gl
# Descriptions...: ICD自動編碼作業 
# Date & Author..: 07/11/27 by bnlent (No.FUN-7B0014)
# Modify.........: No.FUN-810038 08/02/22 By kim GP5.1 ICD
# Modify.........: No.FUN-850069 08/05/14 By alex 調整說明
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No:MOD-A30091 10/07/23 By Pengu 檢查編碼原則的SQL錯誤
# Modify.........: No.FUN-A90024 10/11/10 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-BC0106 12/02/01 By Jason 新增定義值ima_file
# Modify.........: No.FUN-C20100 12/02/20 By Jason 流水號取號規則變更(非當次流水號+1,而是用料號最大值+1)
# Modify.........: No.MOD-C30328 12/03/10 By bart 當l_icr.icr04為'2'定義值時,取出來的值需再依icr07來擷取資料
 
DATABASE ds    #FUN-850069
 
GLOBALS "../../config/top.global"
 
# Descriptions...: ICD自動編碼作業 
# Return Code....: 40碼長度料號
 
FUNCTION s_aic_auto_no(p_icr01,p_icr02,p_keyvalue,p_ima01)
  DEFINE p_icr01     LIKE icr_file.icr01
  DEFINE p_icr02     LIKE icr_file.icr02
  DEFINE p_keyvalue  STRING
  DEFINE p_ima01     LIKE ima_file.ima01
  DEFINE l_res       STRING
  DEFINE l_sql       STRING
  DEFINE l_str,l_tmp STRING
  DEFINE l_value     LIKE type_file.chr1000
  DEFINE l_i         LIKE type_file.num5
  DEFINE l_fldrec    DYNAMIC ARRAY OF RECORD
                     fld LIKE gae_file.gae02
                     END RECORD
  DEFINE l_ice01     LIKE ice_file.ice01
  DEFINE l_ice02     LIKE ice_file.ice02
  DEFINE l_ice14     LIKE ice_file.ice14
  DEFINE l_flow      LIKE type_file.num10
  DEFINE l_db_type   STRING
  DEFINE l_cnt       LIKE type_file.num5
  DEFINE l_dbs       STRING
  DEFINE l_yy,l_mm,l_dd,l_wk STRING
  DEFINE l_icr       RECORD LIKE icr_file.*
  DEFINE l_sfbiicd08 LIKE sfbi_file.sfbiicd08
  DEFINE l_sfbiicd01 LIKE sfbi_file.sfbiicd01
  DEFINE l_sfb05     LIKE sfb_file.sfb05
  DEFINE l_sfbiicd02 LIKE sfbi_file.sfbiicd02
  DEFINE l_flag      LIKE type_file.chr1       #FUN-A90024
 
  LET l_db_type=cl_db_get_database_type()
 
  #取出字符串
  CALL l_fldrec.clear()
  LET l_str=p_keyvalue
  LET l_str=l_str.trim()
  WHILE TRUE
     LET l_tmp = l_str.subString(1,l_str.getIndexOf("||",1)-1)
     IF l_str.getIndexOf("||",1)=0 THEN
        IF l_str is NOT NULL THEN
           LET l_tmp=l_str
           LET l_str=NULL
        END IF
     END IF
     LET l_str = l_str.subString(l_str.getIndexOf("||",1)+2,
                                 l_str.getLength())
     IF l_tmp IS NOT NULL THEN
        LET l_i=l_fldrec.getlength()
        LET l_fldrec[l_i+1].fld=l_tmp
     END IF
     IF l_str IS NULL THEN EXIT WHILE END IF
  END WHILE
 
 
  #依照p_icr01,p_icr02,抓取icr_file的所有數據,
  #依照順序,取出各順序定義的字符串,組合回傳一個編碼字符串 (=>l_res)
  LET l_flow=0
  LET l_res=''
  LET l_sql = "SELECT * FROM icr_file WHERE icr01 = '",p_icr01,"' AND icr02 = '",p_icr02,"' ORDER BY icr03"
  PREPARE s_aic_auto_no_pre FROM l_sql
  DECLARE s_aic_auto_no_cs CURSOR FOR s_aic_auto_no_pre
  FOREACH s_aic_auto_no_cs INTO l_icr.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err('Foreach s_aic_auto_no_cs',SQLCA.sqlcode,0)
      EXIT FOREACH
   END IF
     #LET l_flow=l_flow+1   #FUN-C20100 mark
     CASE l_icr.icr04
        WHEN "1"  #(固定值)
           LET l_res=l_res,l_icr.icr05
        WHEN "2"  #(定義值)
           LET l_sql=''
           CASE l_icr.icr06
              WHEN "ice_file"
                 CASE p_icr02
                    WHEN p_icr02 ='1'
                       LET l_sql="SELECT ",l_icr.icr061," FROM ",l_icr.icr06,
                                 " WHERE ice01='",l_fldrec[1].fld,"'",
                                 "   AND ice02='",l_fldrec[2].fld,"'",
                                 "   AND ice14='",l_fldrec[3].fld,"'"
                    WHEN p_icr02 ='2'
                       LET l_sql="SELECT ",l_icr.icr061," FROM ",l_icr.icr06,
                                 " WHERE ice01='",l_fldrec[1].fld,"'",
                                 "   AND ice02='",l_fldrec[2].fld,"'",
                                 "   AND ice04= ",l_fldrec[3].fld,
                                 "   AND ice14='",l_fldrec[4].fld,"'"
                    WHEN p_icr02='3'
                       SELECT ice02,ice14 INTO l_ice02,l_ice14 FROM ice_file WHERE ice01=l_fldrec[1].fld
                       LET l_sql="SELECT DISTINCT ",l_icr.icr061," FROM ",l_icr.icr06,
                                 " WHERE ice01='",l_fldrec[1].fld,"'",
                                 "   AND ice02='",l_ice02,"'",
                                 "   AND ice14='",l_ice14,"'"
                 END CASE
 
              WHEN "icw_file"
                 LET l_sql="SELECT DISTINCT ",l_icr.icr061," FROM ",l_icr.icr06,
                           " WHERE icw01='",l_fldrec[2].fld,"'"
 
              WHEN "ics_file"
                 LET l_sql="SELECT DISTINCT ",l_icr.icr061," FROM ",l_icr.icr06,
                           " WHERE ics00='",l_fldrec[1].fld,"'"

              #FUN-BC0106 --START--
              WHEN "ima_file"
                 LET l_sql="SELECT DISTINCT ",l_icr.icr061," FROM ",l_icr.icr06,
                           " WHERE ima01='",p_ima01,"'"
              #FUN-BC0106 --END--             
 
              WHEN "ick_file"
                SELECT sfb05 INTO l_sfb05 
                  FROM sfb_file 
                 WHERE sfb01 = l_fldrec[1].fld 
                SELECT sfbiicd01,sfbiicd08 INTO l_sfbiicd01,l_sfbiicd08
                  FROM sfbi_file
                 WHERE sfbi01 =l_fldrec[1].fld 
                LET l_sql="SELECT DISTINCT ",l_icr.icr061," FROM ",l_icr.icr06,
                          " WHERE ick01='",l_sfb05,"' AND ick02='",l_sfbiicd08,"'",
                          "   AND ick09='",l_sfbiicd01,"'"
 
              WHEN "icq_file"
                SELECT sfbiicd01,sfbiicd02 INTO l_sfbiicd01,l_sfbiicd02
                  FROM sfbi_file
                 WHERE sfbi01 =l_fldrec[1].fld 
                LET l_sql="SELECT DISTINCT ",l_icr.icr061," FROM ",l_icr.icr06,
                          " WHERE icq01='",l_sfbiicd01,"' AND icq02='",l_sfbiicd02,"'"
           END CASE
           IF NOT cl_null(l_sql) THEN
              DECLARE s_aic_auto_no_cs1 CURSOR FROM l_sql
              OPEN s_aic_auto_no_cs1
              FETCH s_aic_auto_no_cs1 INTO l_value
              CLOSE s_aic_auto_no_cs1
 
              #LET l_str=l_value                 #MOD-C30328 mark
              LET l_str=l_value[1,l_icr.icr07]   #MOD-C30328
              LET l_str=l_str.trim()
              IF NOT cl_null(l_str) THEN
                 #若日期字段,需變更日期格式
                 IF (NOT cl_null(l_icr.icr08))
                   AND (NOT cl_null(l_icr.icr061)) THEN
                    LET l_cnt=0
                    LET l_sql=''
                    
                    #---FUN-A90024---start-----
                    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
                    #目前統一用sch_file紀錄TIPTOP資料結構
                    #判斷日否為日期型態字段
                    #CASE l_db_type
                    #   WHEN "IFX"
                    #      LET l_sql="SELECT COUNT(*) FROM syscolumns ",
                    #                              " WHERE colname = '",l_icr.icr061,"'",
                    #                              "   AND coltype = 7 "  #7:日期型態
                    #   WHEN "ORA"
                    #      LET l_sql="SELECT COUNT(*) FROM all_tab_columns ",
                    #                              " WHERE owner='",g_dbs CLIPPED,"'",
                    #                              "   AND upper(cloumn_name)='",UPSHIFT(l_icr.icr061),"'",
                    #                              "   AND rtrim(upper(data_type))='DATE'"
                    #   WHEN "MSV"
                    #      LET l_sql="SELECT COUNT(*) FROM sys.columns ",
                    #                              " WHERE name='",l_icr.icr061,"'",
                    #                              "   AND system_type_id = 61 "  #61:日期型態
                    #END CASE
                    
                    #IF l_sql IS NOT NULL THEN
                    #   #No.CHI-950007  --Begin
                    #   PREPARE s_aic_auto_no_cs2_p1 FROM l_sql 
#                   #   DECLARE s_aic_auto_no_cs2 CURSOR FROM l_sql
                    #   EXECUTE s_aic_auto_no_cs2_p1 INTO l_cnt
                    #   IF SQLCA.sqlcode THEN
                    #      CALL cl_err('s_aic_auto_no_cs2',SQLCA.sqlcode,0)
                    #      EXIT FOREACH
                    #   END IF
                    #   #No.CHI-950007  --End  
                    #   IF l_cnt>0 THEN  #為日期型態字段
                    LET l_flag = cl_get_column_datetype('', l_icr.icr061 CLIPPED)
                    IF l_flag = 'Y' THEN  #為日期型態字段
                    #---FUN-A90024---end-------
                       LET l_yy=YEAR(l_str)
                       LET l_mm=MONTH(l_str)
                       LET l_dd=DATE(l_str)
                       LET l_wk=WEEKDAY(l_str)
                       CASE l_icr.icr08
                          WHEN "1"  #1.年周
                             LET l_str=l_yy,l_wk
                          WHEN "2"  #2.年月周
                             LET l_str=l_yy,l_mm,l_wk
                          WHEN "3"  #3.年月日
                                LET l_str=l_yy,l_mm,l_dd
                       END CASE
                    END IF
                    #END IF    #FUN-A90024 mark  因為少一個IF l_sql IS NOT NULL判斷
                 END IF
                 LET l_res=l_res,l_str
              END IF
           END IF
        WHEN "3"  #(流水號)
           CALL s_aic_auto_no_icr04_3(l_res) RETURNING l_flow   #FUN-C20100
           CASE l_icr.icr07
              WHEN "1" LET l_str=l_flow USING "&"     #FUN-BC0106 # > &
              WHEN "2" LET l_str=l_flow USING "&&"    #FUN-BC0106 # > &
              WHEN "3" LET l_str=l_flow USING "&&&"   #FUN-BC0106 # > &
              WHEN "4" LET l_str=l_flow USING "&&&&"  #FUN-BC0106 # > &
              WHEN "5" LET l_str=l_flow USING "&&&&&" #FUN-BC0106 # > &
           END CASE
           #LET l_res=l_res,l_flow   #FUN-BC0106 mark
           LET l_res=l_res,l_str
 
     END CASE
  END FOREACH
  LET l_res=l_res.trim()
 
  #總長度不可超過40碼
  IF l_res.getlength()>40 THEN
     LET l_res=l_res.Substring(1,40)
  END IF
  RETURN l_res
END FUNCTION
 
#FUN-810038
# Descriptions...: 開窗取得 編碼原則代號
 
FUNCTION s_aic_auto_no_set(p_icr02)
   DEFINE p_icr01 LIKE icr_file.icr01
   DEFINE p_icr02 LIKE icr_file.icr02
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_where STRING
   DEFINE l_sql   STRING
   DEFINE p_row   LIKE type_file.num5
   DEFINE p_col   LIKE type_file.num5
 
   OPEN WINDOW s_aic_auto_no AT p_row,p_col 
          WITH FORM "sub/42f/s_aic_auto_no"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("s_aic_auto_no")
 
   INPUT p_icr01 WITHOUT DEFAULTS FROM icr01
      AFTER FIELD icr01
         IF NOT cl_null(p_icr01) THEN
            LET l_cnt = 0
            LET l_where=''
            IF NOT cl_null(p_icr02) THEN
               LET l_where=" AND icr02='",p_icr02,"'"   #No:MOD-A30091 modify
            END IF
            LET l_sql="SELECT COUNT(*) FROM icr_file WHERE icr01='",
                      p_icr01,"'",l_where
            DECLARE s_aic_auto_no_set_c CURSOR FROM l_sql
            OPEN s_aic_auto_no_set_c
            FETCH s_aic_auto_no_set_c INTO l_cnt
            CLOSE s_aic_auto_no_set_c
            IF l_cnt=0 THEN
               CALL cl_err3("sel","icr_file",p_icr01,"",100,"","",1)
            END IF
         END IF
      ON ACTION CONTROLP
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_icr01"
         CALL cl_create_qry() RETURNING p_icr01
         DISPLAY p_icr01 TO icr01
         NEXT FIELD icr01
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
            EXIT INPUT
   END INPUT
 
   CLOSE WINDOW s_aic_auto_no
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN NULL
   END IF
   RETURN p_icr01
END FUNCTION

#FUN-C20100 --START--
FUNCTION s_aic_auto_no_icr04_3(l_res)
DEFINE l_res     STRING
DEFINE l_str     STRING  
DEFINE l_sql     STRING
DEFINE l_ima01   LIKE ima_file.ima01
DEFINE l_flow    LIKE type_file.num10
   LET l_sql = "SELECT MAX(ima01) FROM ima_file ",
                " WHERE ima01 LIKE '", l_res, "%' "
   PREPARE s_aic_auto_no_p1 FROM l_sql         
   DECLARE s_aic_auto_no_c1 SCROLL CURSOR FOR s_aic_auto_no_p1
   OPEN s_aic_auto_no_c1
   FETCH s_aic_auto_no_c1 INTO l_ima01
   IF SQLCA.sqlcode THEN
      LET l_flow = 1
      RETURN l_flow
   END IF
   
   LET l_str = l_ima01 
   LET l_flow = l_str.Substring(l_res.getlength() +1 ,l_str.getlength())   
   LET l_flow = l_flow +1
   IF cl_null(l_flow) THEN LET l_flow = 1 END IF  
   CLOSE s_aic_auto_no_c1
   RETURN l_flow
END FUNCTION
#FUN-C20100 --END--
#No.FUN-7B0014
