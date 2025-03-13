# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglp017.4gl
# Descriptions...: 内部交易抵消分录生成作业 
# Input parameter: 
# Return code....:
# Modify.........:NO.FUN-B40104 11/05/05 By jll   合并报表产品作业 
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm         RECORD  
                  yy        LIKE type_file.num5,   #匯入會計年度
                  em        LIKE type_file.num5,   #截止期間   
                  axa01     LIKE axa_file.axa01,   #族群代號
                  axa02     LIKE axa_file.axa02,   #上层公司编号
                  axa03     LIKE axa_file.axa03,   #帳別
                  gl        LIKE aac_file.aac01,   #調整單別
                  ver       LIKE axg_file.axg17   #版本        
                  END RECORD,
       x_aaa03    LIKE aaa_file.aaa03,             #上層公司記帳幣別
       g_aaa04    LIKE aaa_file.aaa04,             #現行會計年度
       g_aaa05    LIKE aaa_file.aaa05,             #現行期別
       g_aaa07    LIKE aaa_file.aaa07,             #關帳日期
       g_bdate    LIKE type_file.dat,              #期間起始日期  #No.FUN-680098     DATE
       g_edate    LIKE type_file.dat,              #期間起始日期  #No.FUN-680098     DATE
       g_dbs_gl   LIKE type_file.chr21,                           #No.FUN-680098     VARCHAR(21)
       g_bookno   LIKE aea_file.aea00,             #帳別
       ls_date         STRING,                     #No:FUN-570145
       l_flag          LIKE type_file.chr1,        #NO.FUN-570145      #No.FUN-680098 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,        #NO.FUN-570145      #No.FUN-680098 VARCHAR(1)    
       g_axg      RECORD LIKE axg_file.*,          #FUN-760053 add
       g_rate     LIKE type_file.num20_6,          #FUN-770069 mod
       g_aac      RECORD LIKE aac_file.*,
       g_axi      RECORD LIKE axi_file.*,
       g_axj      RECORD LIKE axj_file.*,
       g_i        LIKE type_file.num5,             #count/index for any purpose     #No.FUN-680098 SMALLINT
       g_amt      LIKE axg_file.axg08,             #FUN-5A011                       #No.FUN-680098 DECIMAL(20,6)    
       g_axg04    LIKE axg_file.axg04,             #FUN-770068 add 09/12                       #No.FUN-680098 DECIMAL(20,6)    
       g_axk10_d  LIKE axk_file.axk10,             #FUN-750078 add
       g_axk10_c  LIKE axk_file.axk10,             #FUN-750078 add
       g_axff     RECORD LIKE axff_file.*, 
       g_axt03    LIKE axt_file.axt03,             #FUN-750078 add
       g_axs03    LIKE axs_file.axs03,             #FUN-760053 add
       g_axu03    LIKE axu_file.axu03,             #FUN-760053 add
       g_affil    LIKE axj_file.axj05,             #FUN-760053 add
       g_dc       LIKE axj_file.axj06,             #FUN-760053 add
       g_flag_r   LIKE type_file.chr1,             #FUN-760053 add
       g_yy       LIKE type_file.num5,             #FUN-770069 add
       g_mm       LIKE type_file.num5            #FUN-770069 add
DEFINE g_dbs_axz03     LIKE type_file.chr21        #FUN-920067
DEFINE g_axz03         LIKE axz_file.axz03         #FUN-920067
DEFINE g_sql           STRING                      #FUN-920067
DEFINE g_aaw01_axb04  LIKE aaw_file.aaw01        #FUN-930117
DEFINE g_dbs_axb04     LIKE type_file.chr21        #FUN-930117
DEFINE g_newno         LIKE axi_file.axi01         #FUN-930144
DEFINE g_axa        DYNAMIC ARRAY OF RECORD        
                    axa01      LIKE axa_file.axa01,  #族群代號
                    axa02      LIKE axa_file.axa02,  #上層公司
                    axz08      LIKE axz_file.axz08,  #关系人
                    axa03      LIKE axa_file.axa03   #帳別
                    END RECORD 
DEFINE g_axk09_o    LIKE axk_file.axk09,             #期別
       g_axk09_o1   LIKE axk_file.axk09,             #期別  
       g_axk07_o    LIKE axk_file.axk07,             #異動碼值
       g_axk07_o1   LIKE axk_file.axk07             #異動碼值 
DEFINE g_axg07_o    LIKE axg_file.axg07,             #期別
       g_axg07_o1   LIKE axg_file.axg07             #期別  
DEFINE g_axk07      LIKE axk_file.axk07      #FUN-960096
DEFINE g_axj07_total  LIKE axj_file.axj07    #FUN-970046
DEFINE g_cnt_axf09  LIKE type_file.num5      #FUN-A30079
DEFINE g_cnt_axf10  LIKE type_file.num5      #FUN-A30079
DEFINE g_dbs_axf09  LIKE azp_file.azp03      #FUN-A30079 
DEFINE g_dbs_axf10  LIKE azp_file.azp03      #FUN-A30079 
DEFINE g_aaw01_axf09 LIKE aaw_file.aaw01   #FUN-A30079
DEFINE g_aaw01_axf10 LIKE aaw_file.aaw01   #FUN-A30079
#----FUN-A60038 start---
DEFINE g_dept        DYNAMIC ARRAY OF RECORD        
                     axa01      LIKE axa_file.axa01,  #族群代號
                     axa02      LIKE axa_file.axa02,  #上層公司
                     axa03      LIKE axa_file.axa03,  #帳別
                     axb04      LIKE axb_file.axb04,  #下層公司
                     axb05      LIKE axb_file.axb05   #帳別  
                     END RECORD
DEFINE l_rate        LIKE axp_file.axp05             #功能幣別匯率    
DEFINE l_rate1       LIKE axp_file.axp05             #記帳幣別匯率   
#------FUN-A60038 end---
DEFINE g_axf09_axz05 LIKE axz_file.axz05   #FUN-A90006
DEFINE g_axf10_axz05 LIKE axz_file.axz05   #FUN-A90006
DEFINE g_axz08       LIKE axz_file.axz08   #FUN-A90006
DEFINE g_axz08_axf10 LIKE axz_file.axz08   #FUN-A90006
DEFINE g_low_axf09        LIKE type_file.num5    #FUN-A90006
DEFINE g_up_axf09         LIKE type_file.num5    #FUN-A90006
DEFINE g_low_axf10        LIKE type_file.num5    #FUN-A90006
DEFINE g_up_axf10         LIKE type_file.num5    #FUN-A90006
DEFINE g_axa02_axf09      LIKE axa_file.axa02    #FUN-A90006
DEFINE g_axa02_axf10      LIKE axa_file.axa02    #FUN-A90006
DEFINE g_axa09_axf09      LIKE axa_file.axa09    #FUN-A90006
DEFINE g_axa09_axf10      LIKE axa_file.axa09    #FUN-A90006
DEFINE g_axz06_axf09      LIKE axz_file.axz06    #FUN-A90006
DEFINE g_axz06_axf10      LIKE axz_file.axz06    #FUN-A90006
#---FUN-A90026 start-----------------------------------
DEFINE g_aej              RECORD 
                          aej04  LIKE aej_file.aej04,
                          aej05  LIKE aej_file.aej05,
                          aej07  LIKE aej_file.aej07,
                          aej08  LIKE aej_file.aej08,
                          aej09  LIKE aej_file.aej09,
                          aej10  LIKE aej_file.aej10,
                          aej11  LIKE aej_file.aej11
                          END RECORD
DEFINE g_aek              RECORD 
                          aek04  LIKE aek_file.aek04,
                          aek05  LIKE aek_file.aek05,
                          aek06  LIKE aek_file.aek06,
                          aek08  LIKE aek_file.aek08,
                          aek09  LIKE aek_file.aek09,
                          aek10  LIKE aek_file.aek10,
                          aek11  LIKE aek_file.aek11
                          END RECORD
DEFINE g_aem              RECORD 
                          aem04  LIKE aem_file.aem04,
                          aem05  LIKE aem_file.aem05,
                          aem06  LIKE aem_file.aem06,
                          aem07  LIKE aem_file.aem07,
                          aem08  LIKE aem_file.aem08,
                          aem09  LIKE aem_file.aem09,
                          aem11  LIKE aem_file.aem11,
                          aem12  LIKE aem_file.aem12,
                          aem13  LIKE aem_file.aem13,
                          aem14  LIKE aem_file.aem14,
                          aem15  LIKE aem_file.aem15
                          END RECORD
#---FUN-AA0005 start---
DEFINE g_axj1             RECORD 
                          axj06  LIKE axj_file.axj06,
                          axj07  LIKE axj_file.axj07
                          END RECORD
#---FUN-AA0005 end------
DEFINE g_axa06            LIKE axa_file.axa06    
DEFINE g_axa05            LIKE axa_file.axa05
DEFINE g_type             LIKE type_file.chr1  
DEFINE g_flag             LIKE type_file.chr1
#----FUN-A90026 end---------------------------------------
DEFINE g_no               LIKE type_file.num5
DEFINE g_axk              RECORD LIKE axk_file.*
DEFINE g_aaw01            LIKE aaw_file.aaw01
MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file    #總帳預設帳別
   END IF
   INITIALIZE g_bgjob_msgfile TO NULL
   #--FUN-A90026 start----
   LET tm.axa01 = ARG_VAL(1)
   LET tm.axa03 = ARG_VAL(2)
   LET tm.yy    = ARG_VAL(3)
   LET tm.em    = ARG_VAL(4)
   LET tm.gl    = ARG_VAL(5)
   LET tm.ver   = ARG_VAL(6)
   LET g_bgjob  = ARG_VAL(7)

   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   IF cl_null(tm.ver) THEN LET tm.ver = '00' END IF   

   
  SELECT aaw01 INTO g_aaw01 FROM aaw_file WHERE aaw00 = '0'

  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp017_tm(0,0)
        IF cl_sure(21,21) THEN
           SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02     #MOD-660034
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL p017()
           CALL s_showmsg()                       #NO.FUN-710023   
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag    #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag    #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW aglp017_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07      #MOD-660034
          FROM aaa_file WHERE aaa01 = g_bookno            


        SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02     #MOD-660034
       
        LET g_success = 'Y'
        BEGIN WORK
        CALL p017()
        CALL s_showmsg()                       #NO.FUN-710023
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END  IF
  END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION aglp017_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
           l_cnt          LIKE type_file.num5,          #No.FUN-680098 SMALLINT
           l_axa03        LIKE axa_file.axa03           #FUN-580063
   DEFINE  lc_cmd         LIKE type_file.chr1000        #No.FUN-570145       #No.FUN-680098 VARCHAR(500)    
   DEFINE  l_axa09        LIKE axa_file.axa09           #FUN-A30079 
   DEFINE  l_aznn01       LIKE aznn_file.aznn01         #FUN-A90026 
     
   IF s_shut(0) THEN RETURN END IF
   CALL s_dsmark(g_bookno)

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW aglp017_w AT p_row,p_col WITH FORM "agl/42f/aglp017" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()

   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL                   # Defaealt condition
      SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07    #MOD-660034
        FROM aaa_file 
       WHERE aaa01 = g_bookno                  

      LET tm.yy = g_aaa04
      LET tm.em = g_aaa05
      LET tm.ver = '00'    
      LET g_bgjob = 'N'   
      LET tm.axa03 = g_aaw01
      DISPLAY tm.axa03 TO axa03 
      INPUT BY NAME tm.axa01,tm.yy,tm.em,tm.gl,tm.ver,g_bgjob
            WITHOUT DEFAULTS 

         ON ACTION locale
            LET g_change_lang = TRUE    #NO.FUN-570145 
            EXIT INPUT                  #NO.FUN-570145 

         AFTER FIELD axa01
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01 
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,'',"agl-11","","",0)  
                  NEXT FIELD axa01 
               END IF
            END IF

         AFTER FIELD gl
            IF NOT cl_null(tm.gl) THEN
               SELECT *  FROM aac_file        #讀取單據性質資料
                WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
               IF SQLCA.sqlcode THEN          #抱歉,讀不到
                  CALL cl_err3("sel","aac_file",tm.gl,"","agl-035","","",0) 
                  NEXT FIELD gl
               END IF
            END IF
         AFTER FIELD ver      #版本 
            IF cl_null(tm.ver) THEN
               CALL cl_err('','mfg0037',0) NEXT FIELD ver 
            END IF

         
            
         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa1"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01
                  DISPLAY BY NAME tm.axa01
                  NEXT FIELD axa01
               WHEN INFIELD(gl) #單據性質
                  CALL q_aac(FALSE,TRUE,tm.gl,'A',' ',' ','AGL')  
                       RETURNING tm.gl         
                  DISPLAY  BY NAME tm.gl  
                  NEXT FIELD gl     
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         BEFORE INPUT
             CALL cl_qbe_init()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

   END INPUT
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW aglp017_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01= 'aglp017'
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aglp017','9031',1)   
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       " ''",
                       " '",tm.axa01,"'", 
                       " '",tm.axa03,"'", 
                       " '",tm.yy,"'",    
                       " '",tm.em,"'",    
                       " '",tm.gl CLIPPED,"'",
                       " '",tm.ver CLIPPED,"'",     
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('aglp017',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW aglp017_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    EXIT WHILE
END WHILE

END FUNCTION
   
FUNCTION p017()
    #-->step 1 刪除資料
    CALL p017_del()
    IF g_success = 'N' THEN RETURN END IF
 
# --FUN-A90036 先產生換匯差額分錄,並寫入p017_adj_tmp()  換匯分錄寫入
    #-->step 2
   #CALL p017_adj()
# --FUN-A90036 end-----

    #-->step 3 產生調整分錄
    #-->ref.axf_file insert into axi_file,axj_file
    CALL p017_modi()


#--FUN-A90036 mark---
#    #-->step 4 
#    CALL p017_adj()  
#--FUN-A90036 mark--
END FUNCTION
#--FUN-A90026 end-----

FUNCTION p017_del() 
  #-->delete axj_file(調整與銷除分錄底稿單身檔)
  DELETE FROM axj_file 
        WHERE axj00=g_aaw01
          AND axj01 IN (SELECT axi01 FROM axi_file 
                         WHERE axi00=g_aaw01 AND axi05=tm.axa01  
                           AND axi03=tm.yy AND axi04 = tm.em  
                           AND (axi21=tm.ver OR axi21=tm.em) 
                           AND axiconf <> 'X'  #CHI-C80041
                           AND axi08='2'  AND axi081='7')
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","axj_file",g_aaw01,"",SQLCA.sqlcode,"","del axj_file",1) 
     LET g_success = 'N' 
     RETURN 
  END IF 

  #-->delete axi_file(調整與銷除分錄底稿單頭檔)
  DELETE FROM axi_file 
        WHERE axi00=g_aaw01  
          AND axi05=tm.axa01
          AND axi03=tm.yy AND axi04 = tm.em 
          AND (axi21=tm.ver OR axi21=tm.em)
          AND axiconf <> 'X'  #CHI-C80041
          AND axi08='2' AND axi081 = '7'
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","axi_file",tm.axa03,"",SQLCA.sqlcode,"","del axi_file",1)  #No.FUN-660123 
     LET g_success = 'N' 
     RETURN 
  END IF 
END FUNCTION
   
FUNCTION p017_modi()   #產生調整分錄
DEFINE l_sql        STRING
DEFINE l_axff01     LIKE axff_file.axff01
DEFINE l_axff02     LIKE axff_file.axff02
DEFINE l_aag06      LIKE aag_file.aag06
DEFINE l_sum_amt1   LIKE axj_file.axj07
DEFINE l_sum_amt2   LIKE axj_file.axj07
DEFINE l_sum_dc     LIKE axj_file.axj07
DEFINE l_flag_A     LIKE type_file.chr1
DEFINE l_flag_B     LIKE type_file.chr1
DEFINE l_flag       LIKE type_file.chr1
DEFINE i            LIKE type_file.num5

   LET l_sql=
    "SELECT axa01,axa02,axz08,axa03 FROM axa_file,axz_file ",     
    " WHERE axa01='",tm.axa01,"'",
    "   AND axa02 = axz01",
    " UNION ",
    "SELECT axb01,axb04,axz08,axb05 ", 
    "  FROM axb_file,axa_file,axz_file ",
    " WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
    "   AND axb04=axz01",
    "   AND axa01='",tm.axa01,"'"

   PREPARE p017_axa_p1 FROM l_sql
	   DECLARE p017_axa_c1 CURSOR FOR p017_axa_p1

   LET g_no = 1
   FOREACH p017_axa_c1 INTO g_axa[g_no].*
      IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y'                                                      
      END IF  
      IF SQLCA.SQLCODE THEN
         LET g_showmsg=tm.axa01,"/",'',"/",tm.axa03
         CALL s_errmsg('axa01,axa02,axa03',g_showmsg,'for_axa_c1:',STATUS,1) 
         LET g_success = 'N'
         CONTINUE FOREACH      
      END IF
      LET g_no=g_no+1
   END FOREACH
    CALL g_axa.deleteElement(g_no)
   IF g_totsuccess="N" THEN LET g_success="N" END IF 
   LET g_no=g_no-1

   INITIALIZE g_axi.* TO NULL
   INITIALIZE g_axj.* TO NULL

   CALL p017_ins_axi()

   DECLARE p017_axff_cs CURSOR FOR
    SELECT * FROM axff_file 
     WHERE axffacti = 'Y'  ORDER BY axff01
   LET g_axj.axj00 = g_aaw01
   LET g_axj.axj01 = g_axi.axi01
   FOREACH p017_axff_cs INTO g_axff.*   
       IF g_axff.axff06 = '1' OR g_axff.axff07 = '1' THEN  
          CONTINUE FOREACH
       END IF  
       LET l_axff01 = g_axff.axff01[1,4]
       LET l_axff02 = g_axff.axff02[1,4]
       FOR i = 1 TO g_no
           LET l_sql = "SELECT 'A',axk_file.* FROM axk_file ",
                       " WHERE axk00 = '",g_aaw01,"' AND axk01 = '",g_axa[i].axa01,"'",
                       "   AND axk07 = '",g_axa[i].axz08,"'",
                       "   AND axk08 = '",tm.yy,"' AND axk09 = '",tm.em,"'"
           IF l_axff01 = 'MISC' THEN
              LET l_sql = l_sql CLIPPED,
                          " AND axk05 IN(SELECT DISTINCT axss03 FROM axss_file",
                          "               WHERE axss00 = '",g_aaw01,"'",
                          "                 AND axss01 = '",g_axff.axff01,"')"
           ELSE
              LET l_sql = l_sql CLIPPED," AND axk05 = '",g_axff.axff01,"'"
           END IF 
           LET l_sql = l_sql CLIPPED,
                       " UNION ",
                       "SELECT 'B',axk_file.* FROM axk_file ",
                       " WHERE axk00 = '",g_aaw01,"' AND axk01 = '",g_axa[i].axa01,"'",
                       "   AND axk07 = '",g_axa[i].axz08,"'",
                       "   AND axk08 = '",tm.yy,"' AND axk09 = '",tm.em,"'"
           IF l_axff02 = 'MISC' THEN
              LET l_sql = l_sql CLIPPED,
                          " AND axk05 IN(SELECT DISTINCT axtt03 FROM axtt_file",
                          "               WHERE axtt00 = '",g_aaw01,"'",
                          "                 AND axtt01 = '",g_axff.axff02,"'",
                          "                 AND axtt04 != 'Y') "  #是否依據公式設定
           ELSE
              LET l_sql = l_sql CLIPPED," AND axk05 = '",g_axff.axff02,"'"
           END IF
           PREPARE sel_axk_pre01 FROM l_sql
           DECLARE sel_axk_cur01 CURSOR FOR sel_axk_pre01
           FOREACH sel_axk_cur01 INTO l_flag,g_axk.*
               SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file 
                WHERE axj00 = g_aaw01 AND axj01 = g_axi.axi01
               IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF 
               LET g_axj.axj03 = g_axk.axk05
               LET g_axj.axj05 = g_axa[i].axz08 
               IF cl_null(g_axk.axk10) THEN LET g_axk.axk10 = 0 END IF 
               IF cl_null(g_axk.axk11) THEN LET g_axk.axk11 = 0 END IF 
               LET g_axj.axj07 = g_axk.axk10-g_axk.axk11
               SELECT aag06 INTO l_aag06 FROM aag_file 
                WHERE aag00 = g_aaw01 AND aag01 = g_axj.axj03
               IF l_aag06 = '1' THEN  #借余
                  LET g_axj.axj06 = '2'
               ELSE
                  LET g_axj.axj06 = '1'
                  LET g_axj.axj07 = g_axj.axj07*(-1)
               END IF 
               IF l_flag = 'A' THEN
                  LET l_flag_A = g_axj.axj06
               ELSE
                  LET l_flag_B = g_axj.axj06
               END IF 
               LET g_axj.axj04 = g_axk.axk04
               LET g_axj.axjlegal = g_legal    #所属法人    #NO.FUN-B40104
               INSERT INTO axj_file VALUES (g_axj.*)
               IF SQLCA.sqlcode THEN
                  LET g_showmsg=g_axi.axi07,"/",g_axi.axi01                        
                  CALL s_errmsg('axj00,axj01',g_showmsg ,'ins axj',SQLCA.sqlcode,1) 
                  LET g_success = 'N'
               END IF
           END FOREACH
       END FOR
       IF l_axff01 = 'MISC' THEN
          SELECT SUM(axj07) INTO l_sum_amt1 FROM axj_file 
           WHERE axj00 = g_aaw01 AND axj01 = g_axj.axj01
             AND axj06 = l_flag_A
             AND axj03 IN (SELECT DISTINCT axss03 FROM axss_file
                            WHERE axss00 = g_aaw01
                              AND axss01 = g_axff.axff01) 
       ELSE
          SELECT SUM(axj07) INTO l_sum_amt1 FROM axj_file
           WHERE axj00 = g_aaw01 AND axj01 = g_axj.axj01
             AND axj06 = l_flag_A
             AND axj03 = g_axff.axff01
       END IF 
       IF cl_null(l_sum_amt1) THEN LET l_sum_amt1 = 0 END IF 
       IF l_axff02 = 'MISC' THEN
          SELECT SUM(axj07) INTO l_sum_amt2 FROM axj_file
           WHERE axj00 = g_aaw01 AND axj01 = g_axj.axj01
             AND axj06 = l_flag_B
             AND axj03 IN (SELECT DISTINCT axtt03 FROM axtt_file
                            WHERE axtt00 = g_aaw01
                              AND axtt01 = g_axff.axff02
                              AND axtt04!='Y')
       ELSE
          SELECT SUM(axj07) INTO l_sum_amt2 FROM axj_file
           WHERE axj00 = g_aaw01 AND axj01 = g_axj.axj01
             AND axj06 = l_flag_B
             AND axj03 = g_axff.axff02
       END IF
       IF cl_null(l_sum_amt2) THEN LET l_sum_amt2 = 0 END IF
       IF l_sum_amt1<>l_sum_amt2 THEN  #产生差额
          IF l_sum_amt1<l_sum_amt2 THEN
             LET l_sum_dc = l_sum_amt2-l_sum_amt1
             LET g_axj.axj06 = l_flag_A 
          ELSE
             LET l_sum_dc = l_sum_amt1-l_sum_amt2
             LET g_axj.axj06 = l_flag_B
          END IF 
          LET g_axj.axj07 = l_sum_dc
          SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file 
           WHERE axj00 = g_aaw01 AND axj01 = g_axi.axi01
          IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF 
          LET g_axj.axj00= g_aaw01
          LET g_axj.axj01 = g_axi.axi01
          LET g_axj.axj03 = g_axff.axff04
          LET g_axj.axj05 = ' '
          LET g_axj.axjlegal = g_legal   #所属法人 
          INSERT INTO axj_file VALUES (g_axj.*)
          IF SQLCA.sqlcode THEN
             LET g_showmsg=g_axi.axi07,"/",g_axi.axi01
             CALL s_errmsg('axj00,axj01',g_showmsg ,'ins axj',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF  
       END IF 
   END FOREACH
   CALL p017_upd_axi()
END FUNCTION

FUNCTION p017_ins_axi()
DEFINE li_result  LIKE type_file.num5     #No.FUN-560060        #No.FUN-680098 SMALLINT

    INITIALIZE g_axi.* TO NULL

    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
     WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
    IF SQLCA.sqlcode THEN
       LET g_showmsg= tm.gl,"/",'Y',"/",'A'
       CALL s_errmsg('aac01,aacacti,aac11',g_showmsg,'sel aac',SQLCA.sqlcode,0)   #NO.FUN-710023
       RETURN
    END IF
    LET g_axi.axi00  = g_aaw01  #帳別     
    LET g_axi.axi01  = tm.gl         #傳票編號
    CALL s_ymtodate(tm.yy,'0',tm.yy,tm.em)
     RETURNING g_bdate,g_edate
    LET g_axi.axi02  = g_edate       #單據日期
    LET g_axi.axi03  = tm.yy         #調整年度 
    LET g_axi.axi04  = tm.em         #調整月份
    LET g_axi.axi05  = tm.axa01      #族群編號
    SELECT axa02,axa03 INTO g_axi.axi06,g_axi.axi07 FROM axa_file
     WHERE axa01 = tm.axa01 AND axa04 = 'Y'
    LET g_axi.axi08  = '2'           #來源碼 (1.調整作業  2.沖銷 3.會計師調整)
    LET g_axi.axi09  = 'N'           #換匯差額調整否   
    LET g_axi.axiconf= 'Y'           #確認碼
    LET g_axi.axiuser= g_user        #資料所有者
    LET g_axi.axigrup= g_grup        #資料所有群
    LET g_axi.axidate= g_today       #最近修改日
    LET g_axi.axi21  = tm.ver        #版本  
    LET g_axi.axi081 = '7'
    LET g_axi.axilegal = g_legal     #所属法人 
    CALL s_auto_assign_no("agl",g_axi.axi01,g_axi.axi02,"A",
                          "axi_file","axi01",g_plant,"2",g_aaw01)  
    RETURNING li_result,g_axi.axi01
    DISPLAY g_axi.axi01
    IF g_success='N' THEN 
        LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate  
        CALL s_errmsg('axi00,axi01,axi02',g_showmsg,g_axi.axi01,'mfg-059',1)       
        RETURN 
    END IF

    
    INSERT INTO axi_file VALUES(g_axi.*)
    IF SQLCA.sqlcode THEN 
       LET g_showmsg= tm.axa03,"/",tm.gl,"/",g_edate
       CALL s_errmsg('axi00,axi01,axi02 ',g_showmsg,'ins axi',SQLCA.sqlcode,1)            
       RETURN 
    END IF
    
END FUNCTION

FUNCTION p017_upd_axi()
DEFINE l_sum_tot    LIKE axj_file.axj07

    LET l_sum_tot=0
    SELECT SUM(axj07) INTO l_sum_tot  FROM axj_file 
     WHERE axj01=g_axi.axi01 AND axj06='1'
       AND axj00=g_aaw01 
    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF  
    IF STATUS OR cl_null(l_sum_tot) THEN 
       LET g_success='N'
       RETURN
    END IF
    UPDATE axi_file SET axi11 = l_sum_tot 
     WHERE axi01=g_axi.axi01
       AND axi00=g_aaw01  
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
       LET g_success='N' 
       RETURN
    END IF

    LET l_sum_tot=0
    SELECT SUM(axj07) INTO l_sum_tot FROM axj_file 
     WHERE axj01=g_axi.axi01 AND axj06='2'
       AND axj00=g_aaw01 
    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF 
    IF STATUS OR cl_null(l_sum_tot) THEN
       LET g_success='N'
       RETURN
    END IF
    UPDATE axi_file SET axi12 = l_sum_tot 
     WHERE axi01=g_axi.axi01
       AND axi00=g_aaw01  
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
       LET g_success='N'
       RETURN
    END IF
END FUNCTION


#NO.FUN-B40104
