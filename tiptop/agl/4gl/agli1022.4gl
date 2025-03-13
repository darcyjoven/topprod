# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: agli1022.4gl
# Descriptions...: 科目異動碼設定維護作業agli1022
# Date & Author..: No.FUN-5C0015 05/12/08 By GILL
# Modify.........: NO.TQC-640007 06/04/03 BY yiting 異動碼全部皆為空白時，有異動碼重覆的問題
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........; NO.TQC-670050 06/07/13 BY yiting varchar->char
# Modify.........: NO.FUN-680025 06/08/24 BY flowld voucher型報表轉template1
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730020 07/03/18 By Carrier 會計科目加帳套
# Modify.........: No.FUN-860061 08/06/26 By lutingting 報表轉為使用Crystal Report 輸出
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.MOD-920371 09/02/27 By Smapmin 修改變數定義
# Modify.........: No.MOD-930325 09/04/01 By Sarah 當異動碼類型代號的資料來源為1.基本資料時,其來源編號欄位長度若>30,則異動碼輸入控制不可為3
# Modify.........: No.CHI-910038 09/05/12 By Sarah 科目若己有傳票使用,則不允許修改異動碼類型代號
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0078 09/11/12 By liuxqa STANDARD SQL 
# Modify.........: No.FUN-950053 10/08/17 By vealxu 廠商基本資料的關係人設定搭配異動碼彈性設定
# Modify.........: No.FUN-9B0017 10/09/01 By chenmoyan 新增ACTION異動碼固定類型維護
# Modify.........: No.FUN-A70002 10/09/03 By vealxu 科目異動碼5-8輸入時需控管與agls103三數設定一致
# Modify.........: No.TQC-A90146 10/09/28 By xiaofeizhu 重新過單
# Modify.........: No.FUN-A90024 10/11/26 By Jay 將cl_get_field_width()改為cl_get_column_info()
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No:CHI-B70041 11/08/10 By Polly TQC-B10022已修正aed012欄位為KEY值，固將控卡的檢核拿除
# Modify.........: No:MOD-C90007 12/09/03 By Polly 錯誤訊息 agl-891/agl-892 增加條件 abaacti = 'Y'
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
# Modify.........: No:MOD-CC0131 12/12/14 By yinhy aag35,aag351,aag36,aag361不應隱藏

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_aag          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aag00       LIKE aag_file.aag00,       #帳別編號  #No.FUN-730020
        aag01       LIKE aag_file.aag01,       #科目編號
        aag02       LIKE aag_file.aag02,       #科目名稱
        aag20       LIKE aag_file.aag03,       #傳票項次細項立沖
        aag222      LIKE aag_file.aag04,       #立帳別
        aag15       LIKE aag_file.aag15,       #異動碼1類型代號
        ahe02_1     LIKE ahe_file.ahe02,       #異動碼1名稱
        aag151      LIKE aag_file.aag151,      #異動碼1輸入控制
        aag16       LIKE aag_file.aag16,       #異動碼2類型代號
        ahe02_2     LIKE ahe_file.ahe02,       #異動碼2名稱
        aag161      LIKE aag_file.aag161,      #異動碼2輸入控制
        aag17       LIKE aag_file.aag17,       #異動碼3類型代號
        ahe02_3     LIKE ahe_file.ahe02,       #異動碼3名稱
        aag171      LIKE aag_file.aag171,      #異動碼3輸入控制
        aag18       LIKE aag_file.aag18,       #異動碼4類型代號
        ahe02_4     LIKE ahe_file.ahe02,       #異動碼4名稱
        aag181      LIKE aag_file.aag181,      #異動碼4輸入控制
        aag31       LIKE aag_file.aag31,       #異動碼5類型代號
        ahe02_5     LIKE ahe_file.ahe02,       #異動碼5名稱
        aag311      LIKE aag_file.aag311,      #異動碼5輸入控制
        aag32       LIKE aag_file.aag32,       #異動碼6類型代號
        ahe02_6     LIKE ahe_file.ahe02,       #異動碼6名稱
        aag321      LIKE aag_file.aag321,      #異動碼6輸入控制
        aag33       LIKE aag_file.aag33,       #異動碼7類型代號
        ahe02_7     LIKE ahe_file.ahe02,       #異動碼7名稱
        aag331      LIKE aag_file.aag331,      #異動碼7輸入控制
        aag34       LIKE aag_file.aag34,       #異動碼8類型代號
        ahe02_8     LIKE ahe_file.ahe02,       #異動碼8名稱
        aag341      LIKE aag_file.aag341,      #異動碼8輸入控制
        aag35       LIKE aag_file.aag35,       #異動碼9類型代號
        ahe02_9     LIKE ahe_file.ahe02,       #異動碼9名稱
        aag351      LIKE aag_file.aag351,      #異動碼9輸入控制
        aag36       LIKE aag_file.aag36,       #異動碼10類型代號
        ahe02_10    LIKE ahe_file.ahe02,       #異動碼10名稱
        aag361      LIKE aag_file.aag361,      #異動碼10輸入控制
        aag37       LIKE aag_file.aag37,       #關係人異動碼類型代號
        ahe02_11    LIKE ahe_file.ahe02,       #關係人異動碼名稱
        aag371      LIKE aag_file.aag371       #關係人異動碼輸入控制
                    END RECORD,
    g_aag_t         RECORD                     #程式變數 (舊值)
        aag00       LIKE aag_file.aag00,       #帳別編號  #No.FUN-730020
        aag01       LIKE aag_file.aag01,       #科目編號
        aag02       LIKE aag_file.aag02,       #科目名稱
        aag20       LIKE aag_file.aag03,       #傳票項次細項立沖
        aag222      LIKE aag_file.aag04,       #立帳別
        aag15       LIKE aag_file.aag15,       #異動碼1類型代號
        ahe02_1     LIKE ahe_file.ahe02,       #異動碼1名稱
        aag151      LIKE aag_file.aag151,      #異動碼1輸入控制
        aag16       LIKE aag_file.aag16,       #異動碼2類型代號
        ahe02_2     LIKE ahe_file.ahe02,       #異動碼2名稱
        aag161      LIKE aag_file.aag161,      #異動碼2輸入控制
        aag17       LIKE aag_file.aag17,       #異動碼3類型代號
        ahe02_3     LIKE ahe_file.ahe02,       #異動碼3名稱
        aag171      LIKE aag_file.aag171,      #異動碼3輸入控制
        aag18       LIKE aag_file.aag18,       #異動碼4類型代號
        ahe02_4     LIKE ahe_file.ahe02,       #異動碼4名稱
        aag181      LIKE aag_file.aag181,      #異動碼4輸入控制
        aag31       LIKE aag_file.aag31,       #異動碼5類型代號
        ahe02_5     LIKE ahe_file.ahe02,       #異動碼5名稱
        aag311      LIKE aag_file.aag311,      #異動碼5輸入控制
        aag32       LIKE aag_file.aag32,       #異動碼6類型代號
        ahe02_6     LIKE ahe_file.ahe02,       #異動碼6名稱
        aag321      LIKE aag_file.aag321,      #異動碼6輸入控制
        aag33       LIKE aag_file.aag33,       #異動碼7類型代號
        ahe02_7     LIKE ahe_file.ahe02,       #異動碼7名稱
        aag331      LIKE aag_file.aag331,      #異動碼7輸入控制
        aag34       LIKE aag_file.aag34,       #異動碼8類型代號
        ahe02_8     LIKE ahe_file.ahe02,       #異動碼8名稱
        aag341      LIKE aag_file.aag341,      #異動碼8輸入控制
        aag35       LIKE aag_file.aag35,       #異動碼9類型代號
        ahe02_9     LIKE ahe_file.ahe02,       #異動碼9名稱
        aag351      LIKE aag_file.aag351,      #異動碼9輸入控制
        aag36       LIKE aag_file.aag36,       #異動碼10類型代號
        ahe02_10    LIKE ahe_file.ahe02,       #異動碼10名稱
        aag361      LIKE aag_file.aag361,      #異動碼10輸入控制
        aag37       LIKE aag_file.aag37,       #關係人異動碼類型代號
        ahe02_11    LIKE ahe_file.ahe02,       #關係人異動碼名稱
        aag371      LIKE aag_file.aag371       #關係人異動碼輸入控制
                    END RECORD,
    g_aag_o         RECORD                     #程式變數 (舊值)
        aag00       LIKE aag_file.aag00,       #帳別編號  #No.FUN-730020
        aag01       LIKE aag_file.aag01,       #科目編號
        aag02       LIKE aag_file.aag02,       #科目名稱
        aag20       LIKE aag_file.aag03,       #傳票項次細項立沖
        aag222      LIKE aag_file.aag04,       #立帳別
        aag15       LIKE aag_file.aag15,       #異動碼1類型代號
        ahe02_1     LIKE ahe_file.ahe02,       #異動碼1名稱
        aag151      LIKE aag_file.aag151,      #異動碼1輸入控制
        aag16       LIKE aag_file.aag16,       #異動碼2類型代號
        ahe02_2     LIKE ahe_file.ahe02,       #異動碼2名稱
        aag161      LIKE aag_file.aag161,      #異動碼2輸入控制
        aag17       LIKE aag_file.aag17,       #異動碼3類型代號
        ahe02_3     LIKE ahe_file.ahe02,       #異動碼3名稱
        aag171      LIKE aag_file.aag171,      #異動碼#輸入控制
        aag18       LIKE aag_file.aag18,       #異動碼#類型代號
        ahe02_4     LIKE ahe_file.ahe02,       #異動碼#名稱
        aag181      LIKE aag_file.aag181,      #異動碼#輸入控制
        aag31       LIKE aag_file.aag31,       #異動碼#類型代號
        ahe02_5     LIKE ahe_file.ahe02,       #異動碼#名稱
        aag311      LIKE aag_file.aag311,      #異動碼#輸入控制
        aag32       LIKE aag_file.aag32,       #異動碼#類型代號
        ahe02_6     LIKE ahe_file.ahe02,       #異動碼#名稱
        aag321      LIKE aag_file.aag321,      #異動碼#輸入控制
        aag33       LIKE aag_file.aag33,       #異動碼#類型代號
        ahe02_7     LIKE ahe_file.ahe02,       #異動碼#名稱
        aag331      LIKE aag_file.aag331,      #異動碼7輸入控制
        aag34       LIKE aag_file.aag34,       #異動碼8類型代號
        ahe02_8     LIKE ahe_file.ahe02,       #異動碼8名稱
        aag341      LIKE aag_file.aag341,      #異動碼8輸入控制
        aag35       LIKE aag_file.aag35,       #異動碼9類型代號
        ahe02_9     LIKE ahe_file.ahe02,       #異動碼9名稱
        aag351      LIKE aag_file.aag351,      #異動碼9輸入控制
        aag36       LIKE aag_file.aag36,       #異動碼10類型代號
        ahe02_10    LIKE ahe_file.ahe02,       #異動碼10名稱
        aag361      LIKE aag_file.aag361,      #異動碼10輸入控制
        aag37       LIKE aag_file.aag37,       #關係人異動碼類型代號
        ahe02_11    LIKE ahe_file.ahe02,       #關係人異動碼名稱
        aag371      LIKE aag_file.aag371       #關係人異動碼輸入控制
                    END RECORD,
    g_wc,g_sql      STRING,   #MOD-920371
    g_rec_b         LIKE type_file.num5,       #單身筆數    #No.FUN-680098  SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT   #No.FUN-680098  SMALLINT
 
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt         LIKE type_file.num10      #No.FUN-680098  INTEGER
DEFINE g_i           LIKE type_file.num5       #count/index for any purpose    #No.FUN-680098 SMALLINT
DEFINE g_dash1_1     LIKE type_file.chr1000    #count/index for any purpose    #No.FUN-680098  VARCHAR(1000)
DEFINE g_arg01      STRING
DEFINE g_arg00      STRING  #No.FUN-730020
#No.FUN-860061---------------start---
DEFINE l_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
DEFINE l_table1     STRING
#No.FUN-860061---------------end--
 
MAIN
#     DEFINEl_time LIKE type_file.chr8             #No.FUN-6A0073
DEFINE p_row,p_col    LIKE type_file.num5                               #No.FUN-680098 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
#No.FUN-860061-----------------start--
   LET l_sql = "aag00.aag_file.aag00,",
               "aag01.aag_file.aag01,",
               "aag02.aag_file.aag02,",
               "aag20.aag_file.aag03,",
               "aag222.aag_file.aag04,",
               "l_gae04.gae_file.gae04,",
               "aag37.aag_file.aag37,", 
               "ahe02_11.ahe_file.ahe02,",
               "aag371.aag_file.aag371" 
   LET l_table = cl_prt_temptable('agli1022',l_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   
   LET l_sql = "aag00.aag_file.aag00,",
               "aag01.aag_file.aag01,",
               "l_aag00.aag_file.aag00,",
               "l_aag01.aag_file.aag01,",
               "sr_1_aag.aag_file.aag15,",
               "sr_1_ahe.ahe_file.ahe02,",
               "sr_1_aag1.aag_file.aag151,",
               "sr_2_aag.aag_file.aag15,",
               "sr_2_ahe.ahe_file.ahe02,",
               "sr_2_aag1.aag_file.aag151,",
               "sr_3_aag.aag_file.aag15,",
               "sr_3_ahe.ahe_file.ahe02,",
               "sr_3_aag1.aag_file.aag151,",
               "sr_4_aag.aag_file.aag15,",
               "sr_4_ahe.ahe_file.ahe02,",
               "sr_4_aag1.aag_file.aag151,",
               "sr_5_aag.aag_file.aag15,",
               "sr_5_ahe.ahe_file.ahe02,",
               "sr_5_aag1.aag_file.aag151,",
               "sr_6_aag.aag_file.aag15,",
               "sr_6_ahe.ahe_file.ahe02,",
               "sr_6_aag1.aag_file.aag151,",
               "sr_7_aag.aag_file.aag15,",
               "sr_7_ahe.ahe_file.ahe02,",
               "sr_7_aag1.aag_file.aag151,", 
               "sr_8_aag.aag_file.aag15,",
               "sr_8_ahe.ahe_file.ahe02,",
               "sr_8_aag1.aag_file.aag151,", 
               "sr_9_aag.aag_file.aag15,",
               "sr_9_ahe.ahe_file.ahe02,",
               "sr_9_aag1.aag_file.aag151,", 
               "sr_10_aag.aag_file.aag15,",
               "sr_10_ahe.ahe_file.ahe02,",
               "sr_10_aag1.aag_file.aag151,",
               "l_gae04_1.gae_file.gae04,",
               "l_gae04_2.gae_file.gae04,",
               "l_gae04_3.gae_file.gae04,",
               "l_gae04_4.gae_file.gae04,",
               "l_gae04_5.gae_file.gae04,",
               "l_gae04_6.gae_file.gae04,",
               "l_gae04_7.gae_file.gae04,",
               "l_gae04_8.gae_file.gae04,",
               "l_gae04_9.gae_file.gae04,",
               "l_gae04_10.gae_file.gae04"
   LET l_table1 = cl_prt_temptable('agli10221',l_sql) CLIPPED
   IF l_table1=-1 THEN EXIT PROGRAM END IF               
#No.FUN-860061-----------------end--
 
    LET p_row = 5 LET p_col = 29
    OPEN WINDOW i1022_w AT p_row,p_col WITH FORM "agl/42f/agli1022"  
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    CALL i1022_show_field()
 
    #No.FUN-730020  --Begin
    LET g_arg00 = ARG_VAL(1)
    LET g_arg01 = ARG_VAL(2)
    IF cl_null(g_arg00) OR cl_null(g_arg01) THEN
       LET g_wc = '1=1' 
    ELSE
       LET g_wc = "aag00 ='",g_arg00,"' AND aag01 ='",g_arg01,"'"
    END IF
    #No.FUN-730020  --End  
    CALL i1022_b_fill(g_wc)
 
    CALL i1022_menu()
    CLOSE WINDOW i1022_w                #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i1022_menu()
 
   WHILE TRUE
      CALL i1022_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i1022_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i1022_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i1022_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
       #FUN-9B0017   ---start
         WHEN "dimension_type"
            IF cl_chk_act_auth() THEN
               CALL i1022_type()
            ELSE
               LET g_action_choice = NULL
            END IF
        #FUN-9B0017   ---end
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_aag),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i1022_q()
   CALL i1022_b_askkey()
END FUNCTION
 
FUNCTION i1022_b()
DEFINE
    l_ac_t           LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680098 SMALLINT 
    l_n              LIKE type_file.num5,     #檢查重複用  #No.FUN-680098 SMALLINT
    l_lock_sw        LIKE type_file.chr1,     #單身鎖住否  #No.FUN-680098 VARCHAR(1)
    p_cmd            LIKE type_file.chr1,     #處理狀態    #No.FUN-680098 VARCHAR(1)
    l_allow_insert   LIKE type_file.chr1,     #可新增否    #No.FUN-680098 VARCHAR(1)
    l_allow_delete   LIKE type_file.chr1,     #可刪除否    #No.FUN-680098 VARCHAR(1)
    l_cntabb         LIKE type_file.num10,                 #No.FUN-680098 INTEGER
    l_cntabg         LIKE type_file.num10,                 #No.FUN-680098 INTEGER
    l_cntabh         LIKE type_file.num10,                 #No.FUN-680098 INTEGER
    l_flag           LIKE type_file.num5      #MOD-930325 add
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
 
    LET g_forupd_sql = "SELECT aag00,aag01,aag02,aag20,aag222,",  #No.FUN-730020
                       "aag15,'',aag151,aag16,'',aag161,",
                       "aag17,'',aag171,aag18,'',aag181,",
                       "aag31,'',aag311,aag32,'',aag321,",
                       "aag33,'',aag331,aag34,'',aag341,",
                       "aag35,'',aag351,aag36,'',aag361,",
                       "aag37,'',aag371",
                       " FROM aag_file",
                       " WHERE aag00 = ? AND aag01=? FOR UPDATE"  #No.FUN-730020
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i1022_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    CALL cl_query_prt_temptable()     #No.FUN-A90024
 
    INPUT ARRAY g_aag WITHOUT DEFAULTS FROM s_aag.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW = l_allow_insert) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
                                                          
               LET g_aag_t.* = g_aag[l_ac].*  #BACKUP
               LET g_aag_o.* = g_aag[l_ac].*  #BACKUP
               OPEN i1022_bcl USING g_aag_t.aag00,g_aag_t.aag01  #No.FUN-730020
               IF STATUS THEN
                  CALL cl_err("OPEN i1022_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i1022_bcl INTO g_aag[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_aag_t.aag01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
     
                  #取得異動碼名稱 --begin
                  CALL i1022_ahe02(g_aag[l_ac].aag15) 
                       RETURNING g_aag[l_ac].ahe02_1
                  CALL i1022_ahe02(g_aag[l_ac].aag16) 
                       RETURNING g_aag[l_ac].ahe02_2
                  CALL i1022_ahe02(g_aag[l_ac].aag17) 
                       RETURNING g_aag[l_ac].ahe02_3
                  CALL i1022_ahe02(g_aag[l_ac].aag18) 
                       RETURNING g_aag[l_ac].ahe02_4
                  CALL i1022_ahe02(g_aag[l_ac].aag31) 
                       RETURNING g_aag[l_ac].ahe02_5
                  CALL i1022_ahe02(g_aag[l_ac].aag32) 
                       RETURNING g_aag[l_ac].ahe02_6
                  CALL i1022_ahe02(g_aag[l_ac].aag33) 
                       RETURNING g_aag[l_ac].ahe02_7
                  CALL i1022_ahe02(g_aag[l_ac].aag34) 
                       RETURNING g_aag[l_ac].ahe02_8
                  CALL i1022_ahe02(g_aag[l_ac].aag35) 
                       RETURNING g_aag[l_ac].ahe02_9
                  CALL i1022_ahe02(g_aag[l_ac].aag36) 
                       RETURNING g_aag[l_ac].ahe02_10
                  CALL i1022_ahe02(g_aag[l_ac].aag37) 
                       RETURNING g_aag[l_ac].ahe02_11
                  #取得異動碼名稱 --end
               END IF
               CALL cl_show_fld_cont()     
            END IF
 
           IF g_aag[l_ac].aag20 = 'Y' THEN
              CALL cl_set_comp_required("aag222",TRUE)
           ELSE
              CALL cl_set_comp_required("aag222",FALSE)
           END IF
 
        AFTER FIELD aag20
          IF NOT cl_null(g_aag[l_ac].aag20) AND 
             g_aag[l_ac].aag20 MATCHES '[YN]' THEN
             #-->已有細項立沖有存在則不可'Y'變'N'
             IF (p_cmd = 'u' AND g_aag_t.aag20 = 'Y' 
                 and g_aag[l_ac].aag20 = 'N') THEN
                SELECT COUNT(*) INTO l_cntabg FROM abg_file
                 WHERE abg03 = g_aag[l_ac].aag01
                   AND abg00 = g_aag[l_ac].aag00  #No.FUN-730020
                IF SQLCA.sqlcode THEN
                   LET l_cntabg = 0
                END IF
     
                SELECT COUNT(*) INTO l_cntabh FROM abh_file
                 WHERE abh03 = g_aag[l_ac].aag01
                   AND abh00 = g_aag[l_ac].aag00  #No.FUN-730020
                IF sqlca.sqlcode THEN
                   LET l_cntabh = 0
                END IF
     
                IF (l_cntabg + l_cntabh) > 0 THEN
                   CALL cl_err('','agl-890',0)
                   LET g_aag[l_ac].aag20 = g_aag_t.aag20
                   DISPLAY BY NAME g_aag[l_ac].aag20
                   NEXT FIELD aag20
                END IF
             END IF
     
             #-->'N'改'Y'借方立帳(aag222 ='1'),如果有存在已確認的傳票資料不可改
             IF (p_cmd = 'u' and  g_aag_t.aag222 = '1' and
                 g_aag_t.aag20 = 'N' and g_aag[l_ac].aag20 = 'Y' ) THEN
                SELECT count(*) INTO l_cntabb FROM aba_file,abb_file
                 WHERE aba01 = abb01 AND aba00 = abb00
                   AND aba19 = 'Y'
                   AND abb03 = g_aag[l_ac].aag01
                   AND abb00 = g_aag[l_ac].aag00  #No.FUN-730020
                   AND abaacti = 'Y'              #MOD-C90007 add
                   AND aba19 <> 'X'   #CHI-C80041
                IF sqlca.sqlcode THEN
                   LET l_cntabb = 0
                END IF
             
                IF l_cntabb > 0 THEN
                   CALL cl_err('','agl-891',1)
                   LET g_aag[l_ac].aag20 = g_aag_t.aag20
                   DISPLAY BY NAME g_aag[l_ac].aag20
                   NEXT FIELD aag20
                END IF
             END IF
             #-->'N'改'Y'貸方立帳(aag222 ='2'),如果有存在的傳票資料不可改
             IF (p_cmd = 'u' and  g_aag_t.aag222 = '2' and
                 g_aag_t.aag20 = 'N' and g_aag[l_ac].aag20 = 'Y' ) THEN
                SELECT count(*) INTO l_cntabb FROM aba_file,abb_file
                 WHERE aba01 = abb01 AND aba00 = abb00
                   AND abb03 = g_aag[l_ac].aag01
                   AND abb00 = g_aag[l_ac].aag00  #No.FUN-730020
                   AND abaacti = 'Y'              #MOD-C90007 add
                   AND aba19 <> 'X'   #CHI-C80041
                IF sqlca.sqlcode THEN
                   LET l_cntabb = 0
                END IF
                IF l_cntabb > 0 THEN
                   CALL cl_err('','agl-892',1)
                   LET g_aag[l_ac].aag20 = g_aag_t.aag20
                   DISPLAY BY NAME g_aag[l_ac].aag20
                   NEXT FIELD aag20
                END IF
             END IF
                
             IF g_aag[l_ac].aag20 = 'Y' THEN
                CALL cl_set_comp_required("aag222",TRUE)
             ELSE
                CALL cl_set_comp_required("aag222",FALSE)
             END IF
 
          END IF
 
 
        AFTER FIELD aag222
           IF NOT cl_null(g_aag[l_ac].aag222) THEN
              IF g_aag[l_ac].aag222 NOT MATCHES '[12]' THEN
                 NEXT FIELD aag222
              END IF
              IF (p_cmd = 'u' and g_aag_t.aag222 != g_aag[l_ac].aag222 ) THEN
              #-->如果已有立帳(abg_file)資料則不可改
                 SELECT COUNT(*) INTO l_cntabg FROM abg_file
                  WHERE abg03 = g_aag[l_ac].aag01
                    AND abg00 = g_aag[l_ac].aag00  #No.FUN-730020
                 IF sqlca.sqlcode THEN
                    LET l_cntabg = 0
                 END IF
        
                 IF l_cntabg > 0 THEN
                    CALL cl_err('','agl-893',0)
                    LET g_aag[l_ac].aag222 = g_aag_t.aag222
                    DISPLAY BY NAME g_aag[l_ac].aag222
                    NEXT FIELD aag222
                 END IF
 
                 #-->如果已有沖帳(abg_file)資料則不可改
                 SELECT COUNT(*) INTO l_cntabh FROM abh_file
                  WHERE abh03 = g_aag[l_ac].aag01
                    AND abh00 = g_aag[l_ac].aag00  #No.FUN-730020
                 IF sqlca.sqlcode THEN
                    LET l_cntabh = 0
                 END IF
 
                 IF l_cntabh > 0 THEN
                    CALL cl_err('','agl-894',0)
                    LET g_aag[l_ac].aag222 = g_aag_t.aag222
                    DISPLAY BY NAME g_aag[l_ac].aag222
                    NEXT FIELD aag222
                 END IF
              END IF
           END IF
 
        AFTER FIELD aag15
           IF NOT cl_null(g_aag[l_ac].aag15) THEN
              CALL i1022_chk_ahe(g_aag[l_ac].aag15)
              IF g_errno THEN
                 NEXT FIELD aag15
              END IF
            #------------------------------No.CHI-B70041---------------------start
            ##str CHI-910038 add
            # IF (p_cmd = 'u' and g_aag_t.aag15 != g_aag[l_ac].aag15) THEN          
            #    #該科目若己有傳票使用,則不允許修改異動碼類型代號
            #    CALL i1022_chk_abb(g_aag[l_ac].aag00,g_aag[l_ac].aag01)
            #    IF NOT cl_null(g_errno) THEN
            #       CALL cl_err(g_aag[l_ac].aag01,g_errno,1)
            #       LET g_aag[l_ac].aag15=g_aag_t.aag15
            #       DISPLAY BY NAME g_aag[l_ac].aag15
            #       NEXT FIELD aag15
            #    END IF
            # END IF
            ##end CHI-910038 add
            #------------------------------No.CHI-B70041---------------------end
           END IF
           LET g_aag[l_ac].ahe02_1 = NULL
           CALL i1022_ahe02(g_aag[l_ac].aag15) 
                RETURNING g_aag[l_ac].ahe02_1
           DISPLAY BY NAME g_aag[l_ac].ahe02_1
 
        AFTER FIELD aag16
           IF NOT cl_null(g_aag[l_ac].aag16) THEN
              CALL i1022_chk_ahe(g_aag[l_ac].aag16)
              IF g_errno THEN
                 NEXT FIELD aag16
              END IF
            #------------------------------No.CHI-B70041---------------------start
            ##str CHI-910038 add
            # IF (p_cmd = 'u' and g_aag_t.aag16 != g_aag[l_ac].aag16) THEN           
            #    #該科目若己有傳票使用,則不允許修改異動碼類型代號
            #    CALL i1022_chk_abb(g_aag[l_ac].aag00,g_aag[l_ac].aag01)
            #    IF NOT cl_null(g_errno) THEN
            #       CALL cl_err(g_aag[l_ac].aag01,g_errno,1)
            #       LET g_aag[l_ac].aag16=g_aag_t.aag16
            #       DISPLAY BY NAME g_aag[l_ac].aag16
            #       NEXT FIELD aag16
            #    END IF
            # END IF
            ##end CHI-910038 add
            #------------------------------No.CHI-B70041---------------------end
           END IF
           LET g_aag[l_ac].ahe02_2 = NULL
           CALL i1022_ahe02(g_aag[l_ac].aag16) 
                RETURNING g_aag[l_ac].ahe02_2
           DISPLAY BY NAME g_aag[l_ac].ahe02_2
 
        AFTER FIELD aag17
           IF NOT cl_null(g_aag[l_ac].aag17) THEN
              CALL i1022_chk_ahe(g_aag[l_ac].aag17)
              IF g_errno THEN
                 NEXT FIELD aag17
              END IF
            #------------------------------No.CHI-B70041---------------------start
            ##str CHI-910038 add
            # IF (p_cmd = 'u' and g_aag_t.aag17 != g_aag[l_ac].aag17) THEN             
            #    #該科目若己有傳票使用,則不允許修改異動碼類型代號
            #    CALL i1022_chk_abb(g_aag[l_ac].aag00,g_aag[l_ac].aag01)
            #    IF NOT cl_null(g_errno) THEN
            #       CALL cl_err(g_aag[l_ac].aag01,g_errno,1)
            #       LET g_aag[l_ac].aag17=g_aag_t.aag17
            #       DISPLAY BY NAME g_aag[l_ac].aag17
            #       NEXT FIELD aag17
            #    END IF
            # END IF
            ##end CHI-910038 add
            #------------------------------No.CHI-B70041---------------------end
           END IF
           LET g_aag[l_ac].ahe02_3 = NULL
           CALL i1022_ahe02(g_aag[l_ac].aag17) 
                RETURNING g_aag[l_ac].ahe02_3
           DISPLAY BY NAME g_aag[l_ac].ahe02_3
 
        AFTER FIELD aag18
           IF NOT cl_null(g_aag[l_ac].aag18) THEN
              CALL i1022_chk_ahe(g_aag[l_ac].aag18)
              IF g_errno THEN
                 NEXT FIELD aag18
              END IF
            #------------------------------No.CHI-B70041---------------------start
            ##str CHI-910038 add
            # IF (p_cmd = 'u' and g_aag_t.aag18 != g_aag[l_ac].aag18) THEN         
            #    #該科目若己有傳票使用,則不允許修改異動碼類型代號
            #    CALL i1022_chk_abb(g_aag[l_ac].aag00,g_aag[l_ac].aag01)
            #    IF NOT cl_null(g_errno) THEN
            #       CALL cl_err(g_aag[l_ac].aag01,g_errno,1)
            #       LET g_aag[l_ac].aag18=g_aag_t.aag18
            #       DISPLAY BY NAME g_aag[l_ac].aag18
            #       NEXT FIELD aag18
            #    END IF
            # END IF
            ##end CHI-910038 add
            #------------------------------No.CHI-B70041---------------------end
           END IF
           LET g_aag[l_ac].ahe02_4 = NULL
           CALL i1022_ahe02(g_aag[l_ac].aag18) 
                RETURNING g_aag[l_ac].ahe02_4
           DISPLAY BY NAME g_aag[l_ac].ahe02_4
 
        AFTER FIELD aag31
           IF NOT cl_null(g_aag[l_ac].aag31) THEN
              CALL i1022_chk_ahe(g_aag[l_ac].aag31)
              IF g_errno THEN
                 NEXT FIELD aag31
              END IF
              #FUN-A70002 start--
              IF cl_null(g_aaz.aaz121) THEN
                 IF NOT cl_null(g_aag[l_ac].aag31) THEN
                     CALL cl_err(g_aag[l_ac].aag31,'agl-503',1)
                     LET g_aag[l_ac].aag31  = NULL
                     DISPLAY BY NAME g_aag[l_ac].aag31
                     NEXT FIELD aag31
                 END IF
              END IF
              #FUN-A70002 end---
             #FUN-9B0017   ---start
              IF g_aag[l_ac].aag31<>g_aaz.aaz121 THEN
                 CALL cl_err(g_aag[l_ac].aag31,'agl-503',1)
                 LET g_aag[l_ac].aag31=g_aag_t.aag31
                 DISPLAY BY NAME g_aag[l_ac].aag31
                 NEXT FIELD aag31
              END IF
             #FUN-9B0017   ---end
            #------------------------------No.CHI-B70041---------------------start
            ##str CHI-910038 add
            # IF (p_cmd = 'u' and g_aag_t.aag31 != g_aag[l_ac].aag31) THEN                    
            #    #該科目若己有傳票使用,則不允許修改異動碼類型代號
            #    CALL i1022_chk_abb(g_aag[l_ac].aag00,g_aag[l_ac].aag01)
            #    IF NOT cl_null(g_errno) THEN
            #       CALL cl_err(g_aag[l_ac].aag01,g_errno,1)
            #       LET g_aag[l_ac].aag31=g_aag_t.aag31
            #       DISPLAY BY NAME g_aag[l_ac].aag31
            #       NEXT FIELD aag31
            #    END IF
            # END IF
            ##end CHI-910038 add
            #------------------------------No.CHI-B70041---------------------end
           END IF
           LET g_aag[l_ac].ahe02_5 = NULL
           CALL i1022_ahe02(g_aag[l_ac].aag31) 
                RETURNING g_aag[l_ac].ahe02_5
           DISPLAY BY NAME g_aag[l_ac].ahe02_5
 
        AFTER FIELD aag32
           IF NOT cl_null(g_aag[l_ac].aag32) THEN
              CALL i1022_chk_ahe(g_aag[l_ac].aag32)
              IF g_errno THEN
                 NEXT FIELD aag32
              END IF
              #FUN-A70002 start--
              IF cl_null(g_aaz.aaz122) THEN
                 IF NOT cl_null(g_aag[l_ac].aag32) THEN
                     CALL cl_err(g_aag[l_ac].aag32,'agl-503',1)
                     LET g_aag[l_ac].aag32  = NULL
                     DISPLAY BY NAME g_aag[l_ac].aag32
                     NEXT FIELD aag32
                 END IF
              END IF
              #FUN-A70002 end---
             #FUN-9B0017   ---start                                                                                                 
              IF g_aag[l_ac].aag32<>g_aaz.aaz122 THEN
                 CALL cl_err(g_aag[l_ac].aag32,'agl-503',1)
                 LET g_aag[l_ac].aag32=g_aag_t.aag32                                                                             
                 DISPLAY BY NAME g_aag[l_ac].aag32    
                 NEXT FIELD aag32                                                                                                   
              END IF                                                                                                                
             #FUN-9B0017   ---end
            #------------------------------No.CHI-B70041---------------------start
            ##str CHI-910038 add
            # IF (p_cmd = 'u' and g_aag_t.aag32 != g_aag[l_ac].aag32) THEN                 
            #    #該科目若己有傳票使用,則不允許修改異動碼類型代號
            #    CALL i1022_chk_abb(g_aag[l_ac].aag00,g_aag[l_ac].aag01)
            #    IF NOT cl_null(g_errno) THEN
            #       CALL cl_err(g_aag[l_ac].aag01,g_errno,1)
            #       LET g_aag[l_ac].aag32=g_aag_t.aag32
            #       DISPLAY BY NAME g_aag[l_ac].aag32
            #       NEXT FIELD aag32
            #    END IF
            # END IF
            ##end CHI-910038 add
            #------------------------------No.CHI-B70041---------------------end
           END IF
           LET g_aag[l_ac].ahe02_6 = NULL
           CALL i1022_ahe02(g_aag[l_ac].aag32) 
                RETURNING g_aag[l_ac].ahe02_6
           DISPLAY BY NAME g_aag[l_ac].ahe02_6
 
        AFTER FIELD aag33
           IF NOT cl_null(g_aag[l_ac].aag33) THEN
              CALL i1022_chk_ahe(g_aag[l_ac].aag33)
              IF g_errno THEN
                 NEXT FIELD aag33
              END IF
              #FUN-A70002 start--
              IF cl_null(g_aaz.aaz123) THEN
                 IF NOT cl_null(g_aag[l_ac].aag33) THEN
                     CALL cl_err(g_aag[l_ac].aag33,'agl-503',1)
                     LET g_aag[l_ac].aag33  = NULL
                     DISPLAY BY NAME g_aag[l_ac].aag33
                     NEXT FIELD aag33
                 END IF
              END IF
              #FUN-A70002 end---
             #FUN-9B0017   ---start                                                                                                 
              IF g_aag[l_ac].aag33<>g_aaz.aaz123 THEN
                 CALL cl_err(g_aag[l_ac].aag33,'agl-503',1)
                 LET g_aag[l_ac].aag33=g_aag_t.aag33                                                                             
                 DISPLAY BY NAME g_aag[l_ac].aag33    
                 NEXT FIELD aag33                                                                                                   
              END IF                                                                                                                
             #FUN-9B0017   ---end
            #------------------------------No.CHI-B70041---------------------start
            ##str CHI-910038 add
            # IF (p_cmd = 'u' and g_aag_t.aag33 != g_aag[l_ac].aag33) THEN                
            #    #該科目若己有傳票使用,則不允許修改異動碼類型代號
            #    CALL i1022_chk_abb(g_aag[l_ac].aag00,g_aag[l_ac].aag01)
            #    IF NOT cl_null(g_errno) THEN
            #       CALL cl_err(g_aag[l_ac].aag01,g_errno,1)
            #       LET g_aag[l_ac].aag33=g_aag_t.aag33
            #       DISPLAY BY NAME g_aag[l_ac].aag33
            #       NEXT FIELD aag33
            #    END IF
            # END IF
            ##end CHI-910038 add
            #------------------------------No.CHI-B70041---------------------end
           END IF
           LET g_aag[l_ac].ahe02_7 = NULL
           CALL i1022_ahe02(g_aag[l_ac].aag33) 
                RETURNING g_aag[l_ac].ahe02_7
           DISPLAY BY NAME g_aag[l_ac].ahe02_7
 
        AFTER FIELD aag34
           IF NOT cl_null(g_aag[l_ac].aag34) THEN
              CALL i1022_chk_ahe(g_aag[l_ac].aag34)
              IF g_errno THEN
                 NEXT FIELD aag34
              END IF
             #str CHI-910038 add
              #FUN-A70002 start--
              IF cl_null(g_aaz.aaz124) THEN
                 IF NOT cl_null(g_aag[l_ac].aag34) THEN
                     CALL cl_err(g_aag[l_ac].aag34,'agl-503',1)
                     LET g_aag[l_ac].aag34  = NULL
                     DISPLAY BY NAME g_aag[l_ac].aag34
                     NEXT FIELD aag34
                 END IF
              END IF
              #FUN-A70002 end---
             #FUN-9B0017   ---start                                                                                                 
              IF g_aag[l_ac].aag34<>g_aaz.aaz124 THEN 
                 CALL cl_err(g_aag[l_ac].aag34,'agl-503',1)
                 LET g_aag[l_ac].aag34=g_aag_t.aag34                                                                             
                 DISPLAY BY NAME g_aag[l_ac].aag34 
                 NEXT FIELD aag34                                                                                                   
              END IF                                                                                                                
             #FUN-9B0017   ---end     
            #------------------------------No.CHI-B70041---------------------start
            # IF (p_cmd = 'u' and g_aag_t.aag34 != g_aag[l_ac].aag34) THEN                    
            #    #該科目若己有傳票使用,則不允許修改異動碼類型代號
            #    CALL i1022_chk_abb(g_aag[l_ac].aag00,g_aag[l_ac].aag01)
            #    IF NOT cl_null(g_errno) THEN
            #       CALL cl_err(g_aag[l_ac].aag01,g_errno,1)
            #       LET g_aag[l_ac].aag34=g_aag_t.aag34
            #       DISPLAY BY NAME g_aag[l_ac].aag34
            #       NEXT FIELD aag34
            #    END IF
            # END IF
            ##end CHI-910038 add
            #------------------------------No.CHI-B70041---------------------end
           END IF
           LET g_aag[l_ac].ahe02_8 = NULL
           CALL i1022_ahe02(g_aag[l_ac].aag34) 
                RETURNING g_aag[l_ac].ahe02_8
           DISPLAY BY NAME g_aag[l_ac].ahe02_8
 
        AFTER FIELD aag35
           IF NOT cl_null(g_aag[l_ac].aag35) THEN
              CALL i1022_chk_ahe(g_aag[l_ac].aag35)
              IF g_errno THEN
                 NEXT FIELD aag35
              END IF
            #------------------------------No.CHI-B70041---------------------start
            ##str CHI-910038 add
            # IF (p_cmd = 'u' and g_aag_t.aag35 != g_aag[l_ac].aag35) THEN                   
            #    #該科目若己有傳票使用,則不允許修改異動碼類型代號
            #    CALL i1022_chk_abb(g_aag[l_ac].aag00,g_aag[l_ac].aag01)
            #    IF NOT cl_null(g_errno) THEN
            #       CALL cl_err(g_aag[l_ac].aag01,g_errno,1)
            #       LET g_aag[l_ac].aag35=g_aag_t.aag35
            #       DISPLAY BY NAME g_aag[l_ac].aag35
            #       NEXT FIELD aag35
            #    END IF
            # END IF
            ##end CHI-910038 add
            #------------------------------No.CHI-B70041---------------------end
           END IF
           LET g_aag[l_ac].ahe02_9 = NULL
           CALL i1022_ahe02(g_aag[l_ac].aag35) 
                RETURNING g_aag[l_ac].ahe02_9
           DISPLAY BY NAME g_aag[l_ac].ahe02_9
 
        AFTER FIELD aag36
           IF NOT cl_null(g_aag[l_ac].aag36) THEN
              CALL i1022_chk_ahe(g_aag[l_ac].aag36)
              IF g_errno THEN
                 NEXT FIELD aag36
              END IF
            #------------------------------No.CHI-B70041---------------------start
            ##str CHI-910038 add
            # IF (p_cmd = 'u' and g_aag_t.aag36 != g_aag[l_ac].aag36) THEN            
            #    #該科目若己有傳票使用,則不允許修改異動碼類型代號
            #    CALL i1022_chk_abb(g_aag[l_ac].aag00,g_aag[l_ac].aag01)
            #    IF NOT cl_null(g_errno) THEN
            #       CALL cl_err(g_aag[l_ac].aag01,g_errno,1)
            #       LET g_aag[l_ac].aag36=g_aag_t.aag36
            #       DISPLAY BY NAME g_aag[l_ac].aag36
            #       NEXT FIELD aag36
            #    END IF
            # END IF
            ##end CHI-910038 add
            #------------------------------No.CHI-B70041---------------------end
           END IF
           LET g_aag[l_ac].ahe02_10 = NULL
           CALL i1022_ahe02(g_aag[l_ac].aag36) 
                RETURNING g_aag[l_ac].ahe02_10
           DISPLAY BY NAME g_aag[l_ac].ahe02_10
 
        AFTER FIELD aag37
           IF NOT cl_null(g_aag[l_ac].aag37) THEN
              CALL i1022_chk_ahe(g_aag[l_ac].aag37)
              IF g_errno THEN
                 NEXT FIELD aag37
              END IF
            #------------------------------No.CHI-B70041---------------------start
            ##str CHI-910038 add
            # IF (p_cmd = 'u' and g_aag_t.aag37 != g_aag[l_ac].aag37) THEN                     
            #    #該科目若己有傳票使用,則不允許修改異動碼類型代號
            #    CALL i1022_chk_abb(g_aag[l_ac].aag00,g_aag[l_ac].aag01)
            #    IF NOT cl_null(g_errno) THEN
            #       CALL cl_err(g_aag[l_ac].aag01,g_errno,1)
            #       LET g_aag[l_ac].aag37=g_aag_t.aag37
            #       DISPLAY BY NAME g_aag[l_ac].aag37
            #       NEXT FIELD aag37
            #    END IF
            # END IF
            ##end CHI-910038 add
            #------------------------------No.CHI-B70041---------------------end
           END IF
           LET g_aag[l_ac].ahe02_11 = NULL
           CALL i1022_ahe02(g_aag[l_ac].aag37) 
                RETURNING g_aag[l_ac].ahe02_11
           DISPLAY BY NAME g_aag[l_ac].ahe02_11
 
        AFTER FIELD aag151
           IF NOT cl_null(g_aag[l_ac].aag151) THEN
              IF g_aag[l_ac].aag151 NOT MATCHES'[123]' THEN
                 NEXT FIELD aag151
              END IF
             #str MOD-930325 add
              IF g_aag[l_ac].aag151 = '3' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag15) RETURNING l_flag
                 IF l_flag THEN
                    CALL cl_err(g_aag[l_ac].aag15,'agl-170',0)
                    NEXT FIELD aag151
                 END IF
              END IF
             #end MOD-930325 add
           END IF
 
        AFTER FIELD aag161
           IF NOT cl_null(g_aag[l_ac].aag161) THEN
              IF g_aag[l_ac].aag161 NOT MATCHES'[123]' THEN
                 NEXT FIELD aag161
              END IF
             #str MOD-930325 add
              IF g_aag[l_ac].aag161 = '3' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag16) RETURNING l_flag
                 IF l_flag THEN
                    CALL cl_err(g_aag[l_ac].aag16,'agl-170',0)
                    NEXT FIELD aag161
                 END IF
              END IF
             #end MOD-930325 add
           END IF
 
        AFTER FIELD aag171
           IF NOT cl_null(g_aag[l_ac].aag171) THEN
              IF g_aag[l_ac].aag171 NOT MATCHES'[123]' THEN
                 NEXT FIELD aag171
              END IF
             #str MOD-930325 add
              IF g_aag[l_ac].aag171 = '3' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag17) RETURNING l_flag
                 IF l_flag THEN
                    CALL cl_err(g_aag[l_ac].aag17,'agl-170',0)
                    NEXT FIELD aag171
                 END IF
              END IF
             #end MOD-930325 add
           END IF
 
        AFTER FIELD aag181
           IF NOT cl_null(g_aag[l_ac].aag181) THEN
              IF g_aag[l_ac].aag181 NOT MATCHES'[123]' THEN
                 NEXT FIELD aag181
              END IF
             #str MOD-930325 add
              IF g_aag[l_ac].aag181 = '3' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag18) RETURNING l_flag
                 IF l_flag THEN
                    CALL cl_err(g_aag[l_ac].aag18,'agl-170',0)
                    NEXT FIELD aag181
                 END IF
              END IF
             #end MOD-930325 add
           END IF
 
        AFTER FIELD aag311
           IF NOT cl_null(g_aag[l_ac].aag311) THEN
              IF g_aag[l_ac].aag311 NOT MATCHES'[123]' THEN
                 NEXT FIELD aag311
              END IF
              #FUN-A70002 start--
              IF cl_null(g_aaz.aaz1211) THEN
                 IF NOT cl_null(g_aag[l_ac].aag311) THEN
                     CALL cl_err(g_aag[l_ac].aag311,'agl-503',1)
                     LET g_aag[l_ac].aag311  = NULL
                     DISPLAY BY NAME g_aag[l_ac].aag311
                     NEXT FIELD aag311
                 END IF
              END IF
              #FUN-A70002 end---
             #FUN-9B0017   ---start
              IF g_aag[l_ac].aag311<>g_aaz.aaz1211 THEN
                 CALL cl_err(g_aag[l_ac].aag311,'agl-503',1)
                 NEXT FIELD aag311
              END IF 
             #FUN-9B0017   ---END 
             #str MOD-930325 add
              IF g_aag[l_ac].aag311 = '3' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag31) RETURNING l_flag
                 IF l_flag THEN
                    CALL cl_err(g_aag[l_ac].aag31,'agl-170',0)
                    NEXT FIELD aag311
                 END IF
              END IF
             #end MOD-930325 add
           END IF
 
        AFTER FIELD aag321
           IF NOT cl_null(g_aag[l_ac].aag321) THEN
              IF g_aag[l_ac].aag321 NOT MATCHES'[123]' THEN
                 NEXT FIELD aag321
              END IF
             #str MOD-930325 add
              #FUN-A70002 start--
              IF cl_null(g_aaz.aaz1221) THEN
                 IF NOT cl_null(g_aag[l_ac].aag321) THEN
                     CALL cl_err(g_aag[l_ac].aag321,'agl-503',1)
                     LET g_aag[l_ac].aag321  = NULL
                     DISPLAY BY NAME g_aag[l_ac].aag321
                     NEXT FIELD aag321
                 END IF
              END IF
              #FUN-A70002 end---
             #FUN-9B0017   ---start                                                                                                 
              IF g_aag[l_ac].aag321<>g_aaz.aaz1221 THEN                                                                             
                 CALL cl_err(g_aag[l_ac].aag321,'agl-503',1)
                 NEXT FIELD aag321                                                                                                  
              END IF                                                                                                                
             #FUN-9B0017   ---END     
             #str MOD-930325 add
              IF g_aag[l_ac].aag321 = '3' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag32) RETURNING l_flag
                 IF l_flag THEN
                    CALL cl_err(g_aag[l_ac].aag32,'agl-170',0)
                    NEXT FIELD aag321
                 END IF
              END IF
             #end MOD-930325 add
           END IF 

        AFTER FIELD aag331
           IF NOT cl_null(g_aag[l_ac].aag331) THEN
              IF g_aag[l_ac].aag331 NOT MATCHES'[123]' THEN
                 NEXT FIELD aag331
              END IF
              #FUN-A70002 start--
              IF cl_null(g_aaz.aaz1231) THEN
                 IF NOT cl_null(g_aag[l_ac].aag331) THEN
                     CALL cl_err(g_aag[l_ac].aag331,'agl-503',1)
                     LET g_aag[l_ac].aag331  = NULL
                     DISPLAY BY NAME g_aag[l_ac].aag331
                     NEXT FIELD aag331
                 END IF
              END IF
              #FUN-A70002 end---
             #FUN-9B0017   ---start                                                                                                 
              IF g_aag[l_ac].aag331<>g_aaz.aaz1231 THEN    
                 CALL cl_err(g_aag[l_ac].aag331,'agl-503',1)                                                                         
                 NEXT FIELD aag331                                                                                                  
              END IF                                                                                                                
             #FUN-9B0017   ---END     
             #str MOD-930325 add
              IF g_aag[l_ac].aag331 = '3' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag33) RETURNING l_flag
                 IF l_flag THEN
                    CALL cl_err(g_aag[l_ac].aag33,'agl-170',0)
                    NEXT FIELD aag331
                 END IF
              END IF
             #end MOD-930325 add
           END IF
 
        AFTER FIELD aag341
           IF NOT cl_null(g_aag[l_ac].aag341) THEN
              IF g_aag[l_ac].aag341 NOT MATCHES'[123]' THEN
                 NEXT FIELD aag341
              END IF
              #FUN-A70002 start--
              IF cl_null(g_aaz.aaz1241) THEN
                 IF NOT cl_null(g_aag[l_ac].aag341) THEN
                     CALL cl_err(g_aag[l_ac].aag341,'agl-503',1)
                     LET g_aag[l_ac].aag341  = NULL
                     DISPLAY BY NAME g_aag[l_ac].aag341
                     NEXT FIELD aag341
                 END IF
              END IF
              #FUN-A70002 end---
             #FUN-9B0017   ---start                                                                                                 
              IF g_aag[l_ac].aag341<>g_aaz.aaz1241 THEN    
                 CALL cl_err(g_aag[l_ac].aag341,'agl-503',1)                                                                         
                 NEXT FIELD aag341                                                                                                  
              END IF                                                                                                                
             #FUN-9B0017   ---END      
             #str MOD-930325 add
              IF g_aag[l_ac].aag341 = '3' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag34) RETURNING l_flag
                 IF l_flag THEN
                    CALL cl_err(g_aag[l_ac].aag34,'agl-170',0)
                    NEXT FIELD aag341
                 END IF
              END IF
             #end MOD-930325 add
           END IF
 
        AFTER FIELD aag351
           IF NOT cl_null(g_aag[l_ac].aag351) THEN
              IF g_aag[l_ac].aag351 NOT MATCHES'[123]' THEN
                 NEXT FIELD aag351
              END IF
             #str MOD-930325 add
              IF g_aag[l_ac].aag351 = '3' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag35) RETURNING l_flag
                 IF l_flag THEN
                    CALL cl_err(g_aag[l_ac].aag35,'agl-170',0)
                    NEXT FIELD aag351
                 END IF
              END IF
             #end MOD-930325 add
           END IF
 
        AFTER FIELD aag361
           IF NOT cl_null(g_aag[l_ac].aag361) THEN
              IF g_aag[l_ac].aag361 NOT MATCHES'[123]' THEN
                 NEXT FIELD aag361
              END IF
             #str MOD-930325 add
              IF g_aag[l_ac].aag361 = '3' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag36) RETURNING l_flag
                 IF l_flag THEN
                    CALL cl_err(g_aag[l_ac].aag36,'agl-170',0)
                    NEXT FIELD aag361
                 END IF
              END IF
             #end MOD-930325 add
           END IF
 
        AFTER FIELD aag371
           IF NOT cl_null(g_aag[l_ac].aag371) THEN
            # IF g_aag[l_ac].aag371 NOT MATCHES'[123]' THEN                  #FUN-950053 mark
              IF g_aag[l_ac].aag371 NOT MATCHES'[1234]' THEN                 #FUN-950053 add 
                 NEXT FIELD aag371
              END IF
             #str MOD-930325 add
              IF g_aag[l_ac].aag371 = '3' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag37) RETURNING l_flag
                 IF l_flag THEN
                    CALL cl_err(g_aag[l_ac].aag37,'agl-170',0)
                    NEXT FIELD aag371
                 END IF
              END IF
             #end MOD-930325 add
             #FUN-950053 ----------------add start-----------------------------
              IF g_aag[l_ac].aag371 = '4' THEN
                 CALL i1022_chk_field(g_aag[l_ac].aag37) RETURNING l_flag
                 IF l_flag THEN 
                    CALL cl_err(g_aag[l_ac].aag37,'agl-170',0)
                    NEXT FIELD aag371
                 END IF 
              END IF 
             #FUN-950053 --------------add end----------------------------   
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_aag[l_ac].* = g_aag_t.*
              CLOSE i1022_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_aag[l_ac].aag01,-263,0)
               LET g_aag[l_ac].* = g_aag_t.*
           ELSE
               #進行總檢查 --begin
               IF g_aag[l_ac].aag20='Y' THEN
                  IF cl_null(g_aag[l_ac].aag222) OR 
                     g_aag[l_ac].aag222 NOT MATCHES '[12]' THEN
                     NEXT FIELD aag222
                  END IF
                
                  IF cl_null(g_aag[l_ac].aag15) AND 
                     cl_null(g_aag[l_ac].aag16) AND
                     cl_null(g_aag[l_ac].aag17) AND 
                     cl_null(g_aag[l_ac].aag18) AND
                     cl_null(g_aag[l_ac].aag31) AND
                     cl_null(g_aag[l_ac].aag32) AND 
                     cl_null(g_aag[l_ac].aag33) AND
                     cl_null(g_aag[l_ac].aag34) AND
                     cl_null(g_aag[l_ac].aag35) AND 
                     cl_null(g_aag[l_ac].aag36) AND
                     cl_null(g_aag[l_ac].aag37) THEN
                     CALL cl_err(g_aag[l_ac].aag20,'agl-914',1)
                     NEXT FIELD aag20
                  END IF
                  IF NOT cl_null(g_aag[l_ac].aag15) THEN
                     IF cl_null(g_aag[l_ac].aag151) OR 
                        g_aag[l_ac].aag151 NOT MATCHES '[23]' THEN
                        CALL cl_err('','agl-923',1)
                        NEXT FIELD aag151
                     END IF
                  END IF
                  IF NOT cl_null(g_aag[l_ac].aag16) THEN
                     IF cl_null(g_aag[l_ac].aag161) OR 
                        g_aag[l_ac].aag161 NOT MATCHES '[23]' THEN
                        CALL cl_err('','agl-923',1)
                        NEXT FIELD aag161
                     END IF
                  END IF
                  IF NOT cl_null(g_aag[l_ac].aag17) THEN
                     IF cl_null(g_aag[l_ac].aag171) OR 
                        g_aag[l_ac].aag171 NOT MATCHES '[23]' THEN
                        CALL cl_err('','agl-923',1)
                        NEXT FIELD aag171
                     END IF
                  END IF
                  IF NOT cl_null(g_aag[l_ac].aag18) THEN
                     IF cl_null(g_aag[l_ac].aag181) OR 
                        g_aag[l_ac].aag181 NOT MATCHES '[23]' THEN
                        CALL cl_err('','agl-923',1)
                        NEXT FIELD aag181
                     END IF
                  END IF
                  IF NOT cl_null(g_aag[l_ac].aag31) THEN
                     IF cl_null(g_aag[l_ac].aag311) OR 
                        g_aag[l_ac].aag311 NOT MATCHES '[23]' THEN
                        CALL cl_err('','agl-923',1)
                        NEXT FIELD aag311
                     END IF
                  END IF
                  IF NOT cl_null(g_aag[l_ac].aag32) THEN
                     IF cl_null(g_aag[l_ac].aag321) OR 
                        g_aag[l_ac].aag321 NOT MATCHES '[23]' THEN
                        CALL cl_err('','agl-923',1)
                        NEXT FIELD aag321
                     END IF
                  END IF
                  IF NOT cl_null(g_aag[l_ac].aag33) THEN
                     IF cl_null(g_aag[l_ac].aag331) OR 
                        g_aag[l_ac].aag331 NOT MATCHES '[23]' THEN
                        CALL cl_err('','agl-923',1)
                        NEXT FIELD aag331
                     END IF
                  END IF
                  IF NOT cl_null(g_aag[l_ac].aag34) THEN
                     IF cl_null(g_aag[l_ac].aag341) OR 
                        g_aag[l_ac].aag341 NOT MATCHES '[23]' THEN
                        CALL cl_err('','agl-923',1)
                        NEXT FIELD aag341
                     END IF
                  END IF
                  IF NOT cl_null(g_aag[l_ac].aag35) THEN
                     IF cl_null(g_aag[l_ac].aag351) OR 
                        g_aag[l_ac].aag351 NOT MATCHES '[23]' THEN
                        CALL cl_err('','agl-923',1)
                        NEXT FIELD aag351
                     END IF
                  END IF
                  IF NOT cl_null(g_aag[l_ac].aag36) THEN
                     IF cl_null(g_aag[l_ac].aag361) OR 
                        g_aag[l_ac].aag361 NOT MATCHES '[23]' THEN
                        CALL cl_err('','agl-923',1)
                        NEXT FIELD aag361
                     END IF
                  END IF
                  IF NOT cl_null(g_aag[l_ac].aag37) THEN
                     IF cl_null(g_aag[l_ac].aag371) OR 
                      # g_aag[l_ac].aag371 NOT MATCHES '[23]' THEN             #FUN-950053 mark
                        g_aag[l_ac].aag371 NOT MATCHES '[234]' THEN            #FUN-950053 add 
                        CALL cl_err('','agl-923',1)
                        NEXT FIELD aag371
                     END IF
                  END IF
               END IF
              
               IF NOT cl_null(g_aag[l_ac].aag151) THEN
                  IF cl_null(g_aag[l_ac].aag15) THEN
                     #異動碼輸入控制若有值，則異動碼類型代號也要有值!
                     CALL cl_err('','agl-029',1)
                     NEXT FIELD aag15
                  END IF
               END IF 
               IF NOT cl_null(g_aag[l_ac].aag161) THEN
                  IF cl_null(g_aag[l_ac].aag16) THEN
                     CALL cl_err('','agl-029',1)
                     NEXT FIELD aag16
                  END IF
               END IF 
               IF NOT cl_null(g_aag[l_ac].aag171) THEN
                  IF cl_null(g_aag[l_ac].aag17) THEN
                     CALL cl_err('','agl-029',1)
                     NEXT FIELD aag17
                  END IF
               END IF 
               IF NOT cl_null(g_aag[l_ac].aag181) THEN
                  IF cl_null(g_aag[l_ac].aag18) THEN
                     CALL cl_err('','agl-029',1)
                     NEXT FIELD aag18
                  END IF
               END IF 
               IF NOT cl_null(g_aag[l_ac].aag311) THEN
                  IF cl_null(g_aag[l_ac].aag31) THEN
                     CALL cl_err('','agl-029',1)
                     NEXT FIELD aag31
                  END IF
               END IF 
               IF NOT cl_null(g_aag[l_ac].aag321) THEN
                  IF cl_null(g_aag[l_ac].aag32) THEN
                     CALL cl_err('','agl-029',1)
                     NEXT FIELD aag32
                  END IF
               END IF 
               IF NOT cl_null(g_aag[l_ac].aag331) THEN
                  IF cl_null(g_aag[l_ac].aag33) THEN
                     CALL cl_err('','agl-029',1)
                     NEXT FIELD aag33
                  END IF
               END IF 
               IF NOT cl_null(g_aag[l_ac].aag341) THEN
                  IF cl_null(g_aag[l_ac].aag34) THEN
                     CALL cl_err('','agl-029',1)
                     NEXT FIELD aag34
                  END IF
               END IF 
               IF NOT cl_null(g_aag[l_ac].aag351) THEN
                  IF cl_null(g_aag[l_ac].aag35) THEN
                     CALL cl_err('','agl-029',1)
                     NEXT FIELD aag35
                  END IF
               END IF 
               IF NOT cl_null(g_aag[l_ac].aag361) THEN
                  IF cl_null(g_aag[l_ac].aag36) THEN
                     CALL cl_err('','agl-029',1)
                     NEXT FIELD aag36
                  END IF
               END IF 
               IF NOT cl_null(g_aag[l_ac].aag371) THEN
                  IF cl_null(g_aag[l_ac].aag37) THEN
                     CALL cl_err('','agl-029',1)
                     NEXT FIELD aag37
                  END IF
               END IF 
 
               IF g_aaz.aaz88 > 1 OR g_aaz.aaz125 > 5 THEN   #FUN-B50105   Add OR g_aaz.aaz125 > 5
                  CALL i1022_chk_aag()
                  IF g_errno THEN
                     NEXT FIELD aag15
                  END IF
               END IF
 
               #進行總檢查 --end
               UPDATE aag_file SET aag20  = g_aag[l_ac].aag20,
                                   aag222 = g_aag[l_ac].aag222,
                                   aag15  = g_aag[l_ac].aag15,
                                   aag151 = g_aag[l_ac].aag151,
                                   aag16  = g_aag[l_ac].aag16,
                                   aag161 = g_aag[l_ac].aag161,
                                   aag17  = g_aag[l_ac].aag17,
                                   aag171 = g_aag[l_ac].aag171,
                                   aag18  = g_aag[l_ac].aag18,
                                   aag181 = g_aag[l_ac].aag181,
                                   aag31  = g_aag[l_ac].aag31,
                                   aag311 = g_aag[l_ac].aag311,
                                   aag32  = g_aag[l_ac].aag32,
                                   aag321 = g_aag[l_ac].aag321,
                                   aag33  = g_aag[l_ac].aag33,
                                   aag331 = g_aag[l_ac].aag331,
                                   aag34  = g_aag[l_ac].aag34,
                                   aag341 = g_aag[l_ac].aag341,
                                   aag35  = g_aag[l_ac].aag35,
                                   aag351 = g_aag[l_ac].aag351,
                                   aag36  = g_aag[l_ac].aag36,
                                   aag361 = g_aag[l_ac].aag361,
                                   aag37  = g_aag[l_ac].aag37,
                                   aag371 = g_aag[l_ac].aag371
                WHERE aag01 = g_aag_t.aag01
                  AND aag00 = g_aag_t.aag00   #No.FUN-730020
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_aag[l_ac].aag01,SQLCA.sqlcode,0)   #No.FUN-660123
                  CALL cl_err3("upd","aag_file",g_aag_t.aag00,g_aag_t.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
                  LET g_aag[l_ac].* = g_aag_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()            # 新增
           LET l_ac_t = l_ac                # 新增
 
           IF INT_FLAG THEN                
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_aag[l_ac].* = g_aag_t.*
              END IF
              CLOSE i1022_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i1022_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(aag20) AND l_ac > 1 THEN
              LET g_aag[l_ac].* = g_aag[l_ac-1].*
              LET g_aag[l_ac].aag00 = g_aag_t.aag00  #No.FUN-730020
              LET g_aag[l_ac].aag01 = g_aag_t.aag01
              LET g_aag[l_ac].aag02 = g_aag_t.aag02
              DISPLAY BY NAME g_aag[l_ac].*
              NEXT FIELD aag20
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION CONTROLP
           CASE 
              WHEN INFIELD(aag15) #異動代碼1
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ahe"
                   LET g_qryparam.default1 = g_aag[l_ac].aag15
                   CALL cl_create_qry() RETURNING g_aag[l_ac].aag15
                   DISPLAY BY NAME g_aag[l_ac].aag15
                   NEXT FIELD aag15
              WHEN INFIELD(aag16) #異動代碼2
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ahe"
                   LET g_qryparam.default1 = g_aag[l_ac].aag16
                   CALL cl_create_qry() RETURNING g_aag[l_ac].aag16
                   DISPLAY BY NAME g_aag[l_ac].aag16
                   NEXT FIELD aag16
              WHEN INFIELD(aag17) #異動代碼3
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ahe"
                   LET g_qryparam.default1 = g_aag[l_ac].aag17
                   CALL cl_create_qry() RETURNING g_aag[l_ac].aag17
                   DISPLAY BY NAME g_aag[l_ac].aag17
                   NEXT FIELD aag17
              WHEN INFIELD(aag18) #異動代碼4
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ahe"
                   LET g_qryparam.default1 = g_aag[l_ac].aag18
                   CALL cl_create_qry() RETURNING g_aag[l_ac].aag18
                   DISPLAY BY NAME g_aag[l_ac].aag18
                   NEXT FIELD aag18
              WHEN INFIELD(aag31) #異動代碼5
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ahe"
                   LET g_qryparam.default1 = g_aag[l_ac].aag31
                   CALL cl_create_qry() RETURNING g_aag[l_ac].aag31
                   DISPLAY BY NAME g_aag[l_ac].aag31
                   NEXT FIELD aag31
              WHEN INFIELD(aag32) #異動代碼6
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ahe"
                   LET g_qryparam.default1 = g_aag[l_ac].aag32
                   CALL cl_create_qry() RETURNING g_aag[l_ac].aag32
                   DISPLAY BY NAME g_aag[l_ac].aag32
                   NEXT FIELD aag32
              WHEN INFIELD(aag33) #異動代碼7
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ahe"
                   LET g_qryparam.default1 = g_aag[l_ac].aag33
                   CALL cl_create_qry() RETURNING g_aag[l_ac].aag33
                   DISPLAY BY NAME g_aag[l_ac].aag33
                   NEXT FIELD aag33
              WHEN INFIELD(aag34) #異動代碼8
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ahe"
                   LET g_qryparam.default1 = g_aag[l_ac].aag34
                   CALL cl_create_qry() RETURNING g_aag[l_ac].aag34
                   DISPLAY BY NAME g_aag[l_ac].aag34
                   NEXT FIELD aag34
              WHEN INFIELD(aag35) #異動代碼9
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ahe"
                   LET g_qryparam.default1 = g_aag[l_ac].aag35
                   CALL cl_create_qry() RETURNING g_aag[l_ac].aag35
                   DISPLAY BY NAME g_aag[l_ac].aag35
                   NEXT FIELD aag35
              WHEN INFIELD(aag36) #異動代碼10
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ahe"
                   LET g_qryparam.default1 = g_aag[l_ac].aag36
                   CALL cl_create_qry() RETURNING g_aag[l_ac].aag36
                   DISPLAY BY NAME g_aag[l_ac].aag36
                   NEXT FIELD aag36
              WHEN INFIELD(aag37) #關係人異動代碼
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ahe"
                   LET g_qryparam.default1 = g_aag[l_ac].aag37
                   CALL cl_create_qry() RETURNING g_aag[l_ac].aag37
                   DISPLAY BY NAME g_aag[l_ac].aag37
                   NEXT FIELD aag37
           END CASE
        
    END INPUT
 
    CLOSE i1022_bcl
    COMMIT WORK
 
END FUNCTION
 
#str MOD-930325 add
FUNCTION i1022_chk_field(p_aag15)
   DEFINE p_aag15  LIKE aag_file.aag15
   DEFINE l_flag   LIKE type_file.num5
   DEFINE l_ahe    RECORD LIKE ahe_file.*
   DEFINE l_length LIKE type_file.num5
   
   SELECT * INTO l_ahe.* FROM ahe_file
    WHERE ahe01=p_aag15 AND ahe03='1'
   IF STATUS THEN
      RETURN 0
   ELSE
      #抓取欄位寬度
      #FUN-9B0078 mod --begin
      #SELECT to_char(decode(data_precision,null,data_length,data_precision),'9999.99')
      #  INTO l_length
      #  FROM user_tab_columns
      # WHERE lower(table_name) =l_ahe.ahe04
      #   AND lower(column_name)=l_ahe.ahe05
      #---FUN-A90024---start-----
      #CALL cl_get_field_width(g_dbs,l_ahe.ahe04,l_ahe.ahe05) RETURNING l_length

      CALL cl_query_prt_getlength(l_ahe.ahe05, 'N', 's', 0)
      SELECT xabc04 INTO l_length 
        FROM xabc WHERE xabc02 = l_ahe.ahe05
      #---FUN-A90024---end-------
      #FUN-9B0078 mod --end
      IF l_length > 30 THEN
         RETURN 1
      ELSE
         RETURN 0
      END IF
   END IF
 
END FUNCTION
#end MOD-930325 add
 
FUNCTION i1022_b_askkey()
   CLEAR FORM
   CALL g_aag.clear()
 
    CONSTRUCT g_wc ON aag00,aag01,aag02,aag20,aag222,  #No.FUN-730020
                      aag15,aag151,aag16,aag161,aag17,aag171,
                      aag18,aag181,aag31,aag311,aag32,aag321,
                      aag33,aag331,aag34,aag341,aag35,aag351,
                      aag36,aag361,aag37,aag371
     FROM s_aag[1].aag00,s_aag[1].aag01,s_aag[1].aag02,s_aag[1].aag20,s_aag[1].aag222,  #No.FUN-730020
          s_aag[1].aag15,s_aag[1].aag151,s_aag[1].aag16,s_aag[1].aag161,
          s_aag[1].aag17,s_aag[1].aag171,s_aag[1].aag18,s_aag[1].aag181,
          s_aag[1].aag31,s_aag[1].aag311,s_aag[1].aag32,s_aag[1].aag321,
          s_aag[1].aag33,s_aag[1].aag331,s_aag[1].aag34,s_aag[1].aag341,
          s_aag[1].aag35,s_aag[1].aag351,s_aag[1].aag36,s_aag[1].aag361,
          s_aag[1].aag37,s_aag[1].aag371
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
 
       ON ACTION controlg      
          CALL cl_cmdask()     
    
       ON ACTION CONTROLP
          CASE
                WHEN INFIELD(aag00)       #帳別
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aaa"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag00
                     NEXT FIELD aag00
                WHEN INFIELD(aag01)       #科目編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_aag02"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag01
                     NEXT FIELD aag01
                WHEN INFIELD(aag15)       #異動代碼1
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ahe"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag15
                     NEXT FIELD aag15
                WHEN INFIELD(aag16)       #異動代碼2
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ahe"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag16
                     NEXT FIELD aag16
                WHEN INFIELD(aag17)       #異動代碼3
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ahe"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag17
                     NEXT FIELD aag17
                WHEN INFIELD(aag18)       #異動代碼4
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ahe"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag18
                     NEXT FIELD aag18
                WHEN INFIELD(aag31)       #異動代碼5
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ahe"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag31
                     NEXT FIELD aag31
                WHEN INFIELD(aag32)       #異動代碼6
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ahe"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag32
                     NEXT FIELD aag32
                WHEN INFIELD(aag33)       #異動代碼7
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ahe"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag33
                     NEXT FIELD aag33
                WHEN INFIELD(aag34)       #異動代碼8
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ahe"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag34
                     NEXT FIELD aag34
                WHEN INFIELD(aag35)       #異動代碼9
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ahe"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag35
                     NEXT FIELD aag35
                WHEN INFIELD(aag36)       #異動代碼10
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ahe"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag36
                     NEXT FIELD aag36
                WHEN INFIELD(aag37)       #關係人異動代碼
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ahe"
                     LET g_qryparam.state= "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO aag37
                     NEXT FIELD aag37
 
          END CASE
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0 
#       LET g_rec_b = 0 
#       RETURN 
#    END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      LET g_rec_b = 0
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i1022_b_fill(g_wc)
END FUNCTION
 
FUNCTION i1022_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2     STRING   #MOD-920371 
 
    LET g_sql = "SELECT aag00,aag01,aag02,aag20,aag222,",  #No.FUN-730020
                "aag15,'',aag151,aag16,'',aag161,",
                "aag17,'',aag171,aag18,'',aag181,",
                "aag31,'',aag311,aag32,'',aag321,",
                "aag33,'',aag331,aag34,'',aag341,",
                "aag35,'',aag351,aag36,'',aag361,",
                "aag37,'',aag371",
                " FROM aag_file",
                " WHERE ", p_wc2 CLIPPED, 
                "   AND aag07 !='1' AND aagacti='Y' ",
                " ORDER BY aag00,aag01"  #No.FUN-730020
 
    PREPARE i1022_pb FROM g_sql
    DECLARE aag_curs CURSOR FOR i1022_pb
 
    CALL g_aag.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH aag_curs INTO g_aag[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
      #取得異動碼名稱 --begin
      CALL i1022_ahe02(g_aag[g_cnt].aag15) 
           RETURNING g_aag[g_cnt].ahe02_1
      CALL i1022_ahe02(g_aag[g_cnt].aag16) 
           RETURNING g_aag[g_cnt].ahe02_2
      CALL i1022_ahe02(g_aag[g_cnt].aag17) 
           RETURNING g_aag[g_cnt].ahe02_3
      CALL i1022_ahe02(g_aag[g_cnt].aag18) 
           RETURNING g_aag[g_cnt].ahe02_4
      CALL i1022_ahe02(g_aag[g_cnt].aag31) 
           RETURNING g_aag[g_cnt].ahe02_5
      CALL i1022_ahe02(g_aag[g_cnt].aag32) 
           RETURNING g_aag[g_cnt].ahe02_6
      CALL i1022_ahe02(g_aag[g_cnt].aag33) 
           RETURNING g_aag[g_cnt].ahe02_7
      CALL i1022_ahe02(g_aag[g_cnt].aag34) 
           RETURNING g_aag[g_cnt].ahe02_8
      CALL i1022_ahe02(g_aag[g_cnt].aag35) 
           RETURNING g_aag[g_cnt].ahe02_9
      CALL i1022_ahe02(g_aag[g_cnt].aag36) 
           RETURNING g_aag[g_cnt].ahe02_10
      CALL i1022_ahe02(g_aag[g_cnt].aag37) 
           RETURNING g_aag[g_cnt].ahe02_11
      #取得異動碼名稱 --end
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
    END FOREACH
    CALL g_aag.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i1022_bp(p_ud)
   DEFINE   p_ud  LIKE type_file.chr1      #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aag TO s_aag.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION dimension_type                        #FUN-9B0017
         LET g_action_choice="dimension_type"         #FUN-9B0017
         EXIT DISPLAY                                 #FUN-9B0017
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 			
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
                                                          
FUNCTION i1022_show_field()
#依參數決定異動碼的多寡
  DEFINE l_field     STRING

#FUN-B50105   ---start   Mark 
# IF g_aaz.aaz88 = 10 THEN
#    RETURN
# END IF
#
# IF g_aaz.aaz88 = 0 THEN
#    LET l_field  = "aag15,ahe02_1,aag151,aag16,ahe02_2,aag161,",
#                   "aag17,ahe02_3,aag171,aag18,ahe02_4,aag181,",
#                   "aag31,ahe02_5,aag311,aag32,ahe02_6,aag321,",
#                   "aag33,ahe02_7,aag331,aag34,ahe02_8,aag341,",
#                   "aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"
# END IF
# IF g_aaz.aaz88 = 1 THEN
#    LET l_field  = "aag16,ahe02_2,aag161,",
#                   "aag17,ahe02_3,aag171,aag18,ahe02_4,aag181,",
#                   "aag31,ahe02_5,aag311,aag32,ahe02_6,aag321,",
#                   "aag33,ahe02_7,aag331,aag34,ahe02_8,aag341,",
#                   "aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"
# END IF
# IF g_aaz.aaz88 = 2 THEN
#    LET l_field  = "aag17,ahe02_3,aag171,aag18,ahe02_4,aag181,",
#                   "aag31,ahe02_5,aag311,aag32,ahe02_6,aag321,",
#                   "aag33,ahe02_7,aag331,aag34,ahe02_8,aag341,",
#                   "aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"
# END IF
# IF g_aaz.aaz88 = 3 THEN
#    LET l_field  = "aag18,ahe02_4,aag181,",
#                   "aag31,ahe02_5,aag311,aag32,ahe02_6,aag321,",
#                   "aag33,ahe02_7,aag331,aag34,ahe02_8,aag341,",
#                   "aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"
# END IF
# IF g_aaz.aaz88 = 4 THEN
#    LET l_field  = "aag31,ahe02_5,aag311,aag32,ahe02_6,aag321,",
#                   "aag33,ahe02_7,aag331,aag34,ahe02_8,aag341,",
#                   "aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"
# END IF
# IF g_aaz.aaz88 = 5 THEN
#    LET l_field  = "aag32,ahe02_6,aag321,",
#                   "aag33,ahe02_7,aag331,aag34,ahe02_8,aag341,",
#                   "aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"
# END IF
# IF g_aaz.aaz88 = 6 THEN
#    LET l_field  = "aag33,ahe02_7,aag331,aag34,ahe02_8,aag341,",
#                   "aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"
# END IF
# IF g_aaz.aaz88 = 7 THEN
#    LET l_field  = "aag34,ahe02_8,aag341,",
#                   "aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"
# END IF
# IF g_aaz.aaz88 = 8 THEN
#    LET l_field  = "aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"
# END IF
# IF g_aaz.aaz88 = 9 THEN
#    LET l_field  = "aag36,ahe02_10,aag361"
# END IF
#FUN-B50105   ---end     Mark 

#FUN-B50105   ---start   Add
  IF g_aaz.aaz88 = 0 THEN
     LET l_field  = "aag15,ahe02_1,aag151,aag16,ahe02_2,aag161,",
                    "aag17,ahe02_3,aag171,aag18,ahe02_4,aag181"
  END IF
  IF g_aaz.aaz88 = 1 THEN
     LET l_field  = "aag16,ahe02_2,aag161,aag17,ahe02_3,aag171,",
                    "aag18,ahe02_4,aag181"
  END IF
  IF g_aaz.aaz88 = 2 THEN
     LET l_field  = "aag17,ahe02_3,aag171,aag18,ahe02_4,aag181"
  END IF
  IF g_aaz.aaz88 = 3 THEN
     LET l_field  = "aag18,ahe02_4,aag181"
  END IF
  IF g_aaz.aaz88 = 4 THEN
     LET l_field  = ""
  END IF
  IF NOT cl_null(l_field) THEN lET l_field = l_field,"," END IF
  IF g_aaz.aaz125 = 5 THEN
     LET l_field  = l_field,"aag32,ahe02_6,aag321,aag33,ahe02_7,aag331,",
                    "aag34,ahe02_8,aag341"                                   #MOD-CC0131
                    #"aag34,ahe02_8,aag341,aag35,ahe02_9,aag351,",           #MOD-CC0131 mark 
                    #"aag36,ahe02_10,aag361"                                 #MOD-CC0131 mark 
  END IF
  IF g_aaz.aaz125 = 6 THEN
     LET l_field  = l_field,"aag33,ahe02_7,aag331,aag34,ahe02_8,aag341"
                    #"aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"            #MOD-CC0131 mark
  END IF
  IF g_aaz.aaz125 = 7 THEN
     LET l_field  = l_field,"aag34,ahe02_8,aag341"
                    #"aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"            #MOD-CC0131 mark
  END IF
  IF g_aaz.aaz125 = 8 THEN
     #LET l_field  = l_field,"aag35,ahe02_9,aag351,aag36,ahe02_10,aag361"    #MOD-CC0131 mark
  END IF
#FUN-B50105   ---end     Add
 
  CALL cl_set_comp_visible(l_field,FALSE)
 
END FUNCTION
 
FUNCTION i1022_ahe02(p_aag)
  DEFINE  p_aag     LIKE aag_file.aag15,
          l_ahe02   LIKE ahe_file.ahe02
 
  SELECT ahe02 INTO l_ahe02 FROM ahe_file
   WHERE ahe01 = p_aag
 
  RETURN l_ahe02
 
END FUNCTION
 
FUNCTION i1022_chk_ahe(p_aag)
  DEFINE  p_aag     LIKE aag_file.aag15,
          l_n       LIKE type_file.num10      #No.FUN-680098  INTEGER
 
  LET g_errno = ''
  SELECT COUNT(*) INTO l_n FROM ahe_file
   WHERE ahe01 = p_aag
 
  IF l_n <= 0 THEN
     #無此異動碼類型代號，請重新輸入!
     LET g_errno = 'agl-028'
     CALL cl_err(p_aag,g_errno,1)
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION i1022_out()
  DEFINE     l_i          LIKE type_file.num10,       #No.FUN-680098   INTEGER
             l_n          LIKE type_file.num10,       # NO.FUN-680025 add  #No.FUN-680098  INTEGER  
             l_name       LIKE type_file.chr20,       #External(Disk) file name  #No.FUN-680098  VARCHAR(20) 
             l_aag         RECORD
                aag00      LIKE aag_file.aag00,       #帳別  #No.FUN-730020
                aag01      LIKE aag_file.aag01,       #科目編號
                aag02      LIKE aag_file.aag02,       #科目名稱
                aag20      LIKE aag_file.aag03,       #傳票項次細項立沖
                aag222     LIKE aag_file.aag04,       #立帳別
                aag37      LIKE aag_file.aag37,       #關係人異動碼編號
                ahe02_11   LIKE ahe_file.ahe02,       #關係人異動碼名稱
                aag371     LIKE aag_file.aag371       #關係人異動碼輸入控制
                           END RECORD
 
 #No.FUN-860061----------------start--
  DEFINE    l_sql          STRING
  DEFINE    l_temp         LIKE type_file.chr1000
  DEFINE    l_gae041        LIKE gae_file.gae04        
  DEFINE    l_str          STRING
  DEFINE    l_pos1         LIKE type_file.num10
  DEFINE    l_pos2         LIKE type_file.num10
  DEFINE    l_pos3         LIKE type_file.num10
  DEFINE    sr             ARRAY[10] OF RECORD 
            aag            LIKE aag_file.aag15,      
            ahe            LIKE ahe_file.ahe02,      
            aag1           LIKE aag_file.aag151  
            END RECORD
  DEFINE    l_gae04        ARRAY[10] OF LIKE  gae_file.gae04
 #No.FUN-860061----------------end
 
#No.TQC-710076 -- begin --
   IF cl_null(g_wc) THEN
      CALL cl_err("","9057",0)
      RETURN
   END IF
#No.TQC-710076 -- end --
 
#  CALL cl_outnam(g_prog) RETURNING l_name     #No.FUN-860061
# NO.FUN-680025 --start--
 #No.FUN-860061--------------start--MARK 
 #IF g_aaz.aaz88 < 10 THEN 
 #FOR l_n = 1 TO (10-g_aaz.aaz88)
 #   LET g_zaa[44-(l_n-1)*3].zaa06 = 'Y'
 #   LET g_zaa[43-(l_n-1)*3].zaa06 = 'Y'
 #   LET g_zaa[42-(l_n-1)*3].zaa06 = 'Y'
 #END FOR
 #END IF 
 #No.FUN-860061--------------end--MARK 
 CALL cl_prt_pos_len()
 
#No.FUN-860061------------------start--
 LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?)"
 PREPARE insert_prep FROM l_sql
 IF STATUS THEN
    CALL cl_err('insert_prep:',STATUS,1) 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
    EXIT PROGRAM
 END IF
 
 LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
             "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
             "        ?,?,?,?)"
 PREPARE insert_prep1 FROM l_sql
 IF STATUS THEN
    CALL cl_err('insert_prep1:',STATUS,1) 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
    EXIT PROGRAM
 END IF
             
 CALL cl_del_data(l_table)
 CALL cl_del_data(l_table1)
 
 SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'agli1022'    
#No.FUN-860061------------------end
 
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#  #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'agli1022'
#  #g_len長度 = 前段固定長 + 變動長(異動碼1 - 10) + 關係人異動碼長
#  LET g_len = 90 + (g_aaz.aaz88 * 67 ) + 67
 
#  FOR g_i = 1 TO g_len LET g_dash1_1[g_i,g_i] = '=' END FOR
# NO.FUN-680025 ---end--- 
  LET g_sql = " SELECT aag00,aag01,aag02,aag20,aag222,aag37,'',aag371 FROM aag_file ",  #No.FUN-730020
              "  WHERE ", g_wc CLIPPED,
              "  ORDER BY aag00,aag01 "  #No.FUN-730020
              
  PREPARE i1022_pbout FROM g_sql
  DECLARE i1022_bcsout CURSOR FOR i1022_pbout
 
  #START REPORT i1022_rep TO l_name  #No.FUN-860061
 
  FOREACH i1022_bcsout INTO l_aag.*
    CALL i1022_ahe02(l_aag.aag37)
         RETURNING l_aag.ahe02_11
    
    #No.FUN-860061------------------start--
       SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,aag31,aag311,
              aag32,aag321,aag33,aag331,aag34,aag341,aag35,aag351,aag36,aag361
         INTO sr[1].aag,sr[1].aag1,sr[2].aag,sr[2].aag1,
              sr[3].aag,sr[3].aag1,sr[4].aag,sr[4].aag1,
              sr[5].aag,sr[5].aag1,sr[6].aag,sr[6].aag1,
              sr[7].aag,sr[7].aag1,sr[8].aag,sr[8].aag1,
              sr[9].aag,sr[9].aag1,sr[10].aag,sr[10].aag1
        FROM aag_file WHERE aag01 = l_aag.aag01
                        AND aag00 = l_aag.aag00   
 
        FOR l_n = 1 TO g_aaz.aaz88
            CALL i1022_ahe02(sr[l_n].aag)
                 RETURNING sr[l_n].ahe
        END FOR
        
#FUN-B50105   ---start   Add
        FOR l_n = 5 TO g_aaz.aaz125
            CALL i1022_ahe02(sr[l_n].aag)
                 RETURNING sr[l_n].ahe
        END FOR
#FUN-B50105   --end      Add

       #動態列印異動碼資料
        LET l_pos1 = NULL
        LET l_pos2 = NULL
        LET l_pos3 = NULL
        IF g_aaz.aaz88 !=0 OR g_aaz.aaz125 IS NOT NULL THEN   #FUN-B50105   Add   OR g_aaz.aaz125IS NOT NULL
          FOR l_n = 1 TO g_aaz.aaz88
              IF l_n = 1 THEN
                 LET l_pos1 =  91
              ELSE
                 LET l_pos1 = 91 + ((l_n-1) * 67)
              END IF  
              LET l_pos2 = l_pos1 + 21
              LET l_pos3 = l_pos2 + 21
              CALL i1022_get_gae(sr[l_n].aag1,l_n) RETURNING l_gae04[l_n]   
           END FOR 
#FUN-B50105   ---start   Add
          FOR l_n = 5 TO g_aaz.aaz125
              IF l_n = 1 THEN 
                 LET l_pos1 =  91
              ELSE
                 LET l_pos1 = 91 + ((l_n-1) * 67)
              END IF  
              LET l_pos2 = l_pos1 + 21
              LET l_pos3 = l_pos2 + 21
              CALL i1022_get_gae(sr[l_n].aag1,l_n) RETURNING l_gae04[l_n]
           END FOR
#FUN_B50105   ---end     Add
           EXECUTE insert_prep1 USING                                        
                  l_aag.aag00,l_aag.aag01,l_aag.aag00,l_aag.aag01,               
                  sr[1].aag,sr[1].ahe,sr[1].aag1,sr[2].aag,sr[2].ahe,sr[2].aag1, 
                  sr[3].aag,sr[3].ahe,sr[3].aag1,sr[4].aag,sr[4].ahe,sr[4].aag1, 
                  sr[5].aag,sr[5].ahe,sr[5].aag1,sr[6].aag,sr[6].ahe,sr[6].aag1, 
                  sr[7].aag,sr[7].ahe,sr[7].aag1,sr[8].aag,sr[8].ahe,sr[8].aag1, 
                  sr[9].aag,sr[9].ahe,sr[9].aag1,sr[10].aag,sr[10].ahe,          
                  sr[10].aag1,l_gae04[1],l_gae04[2],l_gae04[3],l_gae04[4],l_gae04[5],
                  l_gae04[6],l_gae04[7],l_gae04[8],l_gae04[9],l_gae04[10]                                          
        END IF
                   
    LET l_temp = ' '                         
    IF l_aag.aag222='1' THEN                 
       LET l_temp = 'aag222_1'              
    END IF                                   
    IF l_aag.aag222='2' THEN                 
       LET l_temp = 'aag222_2'               
    END IF                                   
    LET l_gae041 = NULL                       
    SELECT gae04 INTO l_gae041 FROM gae_file  
     WHERE gae01='agli1022'                  
       AND gae02=l_temp                      
       AND gae03=g_lang AND gae11='N' 
    IF cl_null(l_gae041) THEN LET l_gae041 = NULL  END IF 
    IF cl_null(l_aag.aag222)  THEN LET l_aag.aag222 = NULL  END IF   
    EXECUTE insert_prep USING
       l_aag.aag00,l_aag.aag01,l_aag.aag02,l_aag.aag20,l_aag.aag222,l_gae041,
       l_aag.aag37,l_aag.ahe02_11,l_aag.aag371                                              
    #No.FUN-860061------------------end  
 
    #OUTPUT TO REPORT i1022_rep(l_aag.*) No.FUN-860061
  END FOREACH
  
  #No.FUN-860061--------------start--
  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|", 
              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
  
  IF g_zz05 = 'Y' THEN
     CALL cl_wcchp(g_wc,'aag00,aag01,aag02,aag20,aag222,
                         aag15,aag151,aag16,aag161,aag17,aag171,
                         aag18,aag181,aag31,aag311,aag32,aag321,
                         aag33,aag331,aag34,aag341,aag35,aag351,
                         aag36,aag361,aag37,aag371')
          RETURNING l_str
          LET g_str = l_str
  END IF
  
  LET g_str = g_str,";",g_aaz.aaz88,g_aaz.aaz125    #FUN-B50105   Add   ,g_aaz.aaz125
  
  CALL cl_prt_cs3('agli1022','agli1022',l_sql,g_str)                                
  #No.FUN-860061--------------end
#  FINISH REPORT i1022_rep     #No.FUN-860061
                         
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-860061
 
END FUNCTION
 
#No.FUN-860061------------start-- 
#REPORT i1022_rep(p_aag)
#   DEFINE
#       l_trailer_sw  LIKE type_file.chr1,     #No.FUN-680098    VARCHAR(1)
#       p_aag          RECORD
#          aag00       LIKE aag_file.aag00,       #帳別  #No.FUN-730020
#          aag01       LIKE aag_file.aag01,       #科目編號
#          aag02       LIKE aag_file.aag02,       #科目名稱
#          aag20       LIKE aag_file.aag03,       #傳票項次細項立沖
#          aag222      LIKE aag_file.aag04,       #立帳別
#          aag37       LIKE aag_file.aag37,       #關係人異動碼編號
#          ahe02_11    LIKE ahe_file.ahe02,       #關係人異動碼名稱
#          aag371      LIKE aag_file.aag371       #關係人異動碼輸入控制
#                      END RECORD,
#       sr             ARRAY[10] OF RECORD 
#           aag        LIKE aag_file.aag15,      #用來存異動碼1-10
#           ahe        LIKE ahe_file.ahe02,      #用來存異動碼名稱1-10
#           aag1       LIKE aag_file.aag151      #用來存異動碼輸入控制1-10
#                      END RECORD,
#       l_n            LIKE type_file.num10,     #No.FUN-680098     integer
#       l_pos1         LIKE type_file.num10,     #異動碼位置        #No.FUN-680098  integer
#       l_pos2         LIKE type_file.num10,     #異動碼名稱位置    #No.FUN-680098  integer
#       l_pos3         LIKE type_file.num10,     #異動碼輸入控制位置#No.FUN-680098  integer
#       l_temp         LIKE type_file.chr1000,   #No.FUN-680098    VARCHAR(100)            
#       l_gae04        LIKE gae_file.gae04                    
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#
#  ORDER BY p_aag.aag00,p_aag.aag01  #No.FUN-730020
#
#  FORMAT
#    PAGE HEADER
## No.FUN-680025 --start-- 
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##      PRINT ' '
##      LET g_pageno = g_pageno + 1
##      PRINT g_x[2] CLIPPED,g_today ,' ',TIME,
##            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##      PRINT g_dash1_1[1,g_len]
#
#      PRINT COLUMN (g_len-FGL_WIDTH(g_company CLIPPED))/2+1,g_company CLIPPED
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN (g_len-FGL_WIDTH(g_x[1]))/2+1,g_x[1]
#      PRINT ' '
#      PRINT g_dash
# 
#  
##       PRINT COLUMN 1  ,g_x[11],
##             COLUMN 22 ,g_x[12],
##             COLUMN 63 ,g_x[13],
##             COLUMN 80 ,g_x[14];
#       
##       #動態列印表頭
##       LET l_pos1 = NULL
##       LET l_pos2 = NULL
##       LET l_pos3 = NULL
##       IF g_aaz.aaz88 !=0 THEN
##         FOR l_n = 1 TO g_aaz.aaz88
##             IF l_n = 1 THEN
##                LET l_pos1 =  91
##             ELSE
##                LET l_pos1 = 91 + ((l_n-1) * 67)
##             END IF  
##             LET l_pos2 = l_pos1 + 21
##             LET l_pos3 = l_pos2 + 21
##             PRINT COLUMN l_pos1,g_x[((l_n-1)*3) + 15],   #異動碼
##                   COLUMN l_pos2,g_x[((l_n-1)*3) + 16],   #異動碼名稱
##                   COLUMN l_pos3,g_x[((l_n-1)*3) + 17];   #異動碼輸入控制
##         END FOR
##       END IF
#       
##       #列印關係人異動碼
##       IF cl_null(l_pos3) THEN
##          LET l_pos3 = 91
##       ELSE
##          LET l_pos3 = l_pos3 + 25
##       END IF
##       PRINT COLUMN l_pos3,g_x[48],
##             COLUMN l_pos3+23,g_x[49],
##             COLUMN l_pos3+44,g_x[50]
#       
##       #印虛線
##       PRINT COLUMN 1  ,g_x[54],
##             COLUMN 22 ,g_x[55],
##             COLUMN 63 ,g_x[56],
##             COLUMN 80 ,g_x[57];
##       IF g_aaz.aaz88 !=0 THEN
##         FOR l_n = 1 TO g_aaz.aaz88
##             PRINT g_x[45],
##                   g_x[46],
##                   g_x[47];
##         END FOR
##       END IF
##       PRINT g_x[51],g_x[52],g_x[53]
#    PRINT g_x[48],g_x[11],g_x[12],g_x[13],g_x[14],g_x[15],g_x[16],g_x[17],g_x[18],g_x[19],  #No.FUN-730020
#          g_x[20],g_x[21],g_x[22],g_x[23],g_x[24],g_x[25],g_x[26],g_x[27],g_x[28],
#          g_x[29],g_x[30],g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#          g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
#          g_x[47]
#    PRINT g_dash1    
#      LET l_trailer_sw = 'n'
## No.FUN-680025 ---end---
#    BEFORE GROUP OF p_aag.aag01
#
#       SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,aag31,aag311,
#              aag32,aag321,aag33,aag331,aag34,aag341,aag35,aag351,aag36,aag361
#         INTO sr[1].aag,sr[1].aag1,sr[2].aag,sr[2].aag1,
#              sr[3].aag,sr[3].aag1,sr[4].aag,sr[4].aag1,
#              sr[5].aag,sr[5].aag1,sr[6].aag,sr[6].aag1,
#              sr[7].aag,sr[7].aag1,sr[8].aag,sr[8].aag1,
#              sr[9].aag,sr[9].aag1,sr[10].aag,sr[10].aag1
#        FROM aag_file WHERE aag01 = p_aag.aag01
#                        AND aag00 = p_aag.aag00   #No.FUN-730020
#
#        FOR l_n = 1 TO g_aaz.aaz88
#            CALL i1022_ahe02(sr[l_n].aag)
#                 RETURNING sr[l_n].ahe
#        END FOR
#        
#    ON EVERY ROW
#       LET l_temp = ' '
#       IF p_aag.aag222='1' THEN
#          LET l_temp = 'aag222_1'
#       END IF
#       IF p_aag.aag222='2' THEN
#          LET l_temp = 'aag222_2'
#       END IF
#       LET l_gae04 = NULL
#       SELECT gae04 INTO l_gae04 FROM gae_file
#        WHERE gae01='agli1022'
#          AND gae02=l_temp
#          AND gae03=g_lang AND gae11='N'
#
## NO.FUN-680025 --start--
##       PRINT COLUMN 1  ,p_aag.aag01,
##             COLUMN 22 ,p_aag.aag02,
##             COLUMN 63 ,p_aag.aag20,
##             COLUMN 80 ,p_aag.aag222,l_gae04;
#        PRINT COLUMN g_c[48],p_aag.aag00;   #No.FUN-730020
#        PRINT COLUMN g_c[11],p_aag.aag01,
#              COLUMN g_c[12],p_aag.aag02,
#              COLUMN g_c[13],p_aag.aag20,
#              COLUMN g_c[14],p_aag.aag222||":"||l_gae04;
#         
#       #動態列印異動碼資料
#       LET l_pos1 = NULL
#       LET l_pos2 = NULL
#       LET l_pos3 = NULL
#       IF g_aaz.aaz88 !=0 THEN
#         FOR l_n = 1 TO g_aaz.aaz88
#             IF l_n = 1 THEN
#                LET l_pos1 =  91
#             ELSE
#                LET l_pos1 = 91 + ((l_n-1) * 67)
#             END IF  
#             LET l_pos2 = l_pos1 + 21
#             LET l_pos3 = l_pos2 + 21
#             LET l_gae04 = NULL
#             CALL i1022_get_gae(sr[l_n].aag1,l_n) RETURNING l_gae04
##             PRINT COLUMN l_pos1,sr[l_n].aag,               #異動碼
##                   COLUMN l_pos2,sr[l_n].ahe,               #異動碼名稱
##                   COLUMN l_pos3,sr[l_n].aag1,l_gae04;      #異動碼輸入控制
#                
#              PRINT COLUMN g_c[15+(l_n-1)*3],sr[l_n].aag,
#                    COLUMN g_c[16+(l_n-1)*3],sr[l_n].ahe,
#                    COLUMN g_c[17+(l_n-1)*3],sr[l_n].aag1||":"||l_gae04;            
#        END FOR
#       END IF
#
#
#       #列印關係人異動碼
##       IF cl_null(l_pos3) THEN
##          LET l_pos3 = 91
##       ELSE
##          LET l_pos3 = l_pos3 + 25
##       END IF
##       LET l_gae04 = NULL
#       CALL i1022_get_gae(p_aag.aag371,11) RETURNING l_gae04
##       PRINT COLUMN l_pos3,p_aag.aag37,
##             COLUMN l_pos3+23,p_aag.ahe02_11,
##             COLUMN l_pos3+44,p_aag.aag371
#        PRINT COLUMN g_c[45],p_aag.aag37,
#              COLUMN g_c[46],p_aag.ahe02_11,
#              COLUMN g_c[47],p_aag.aag371
## NO.FUN-680025 ---end---  
#    ON LAST ROW 
#       LET l_trailer_sw = 'y'
#       PRINT g_dash
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#                   
# 
#    PAGE TRAILER
#      IF l_trailer_sw = 'n' THEN
#        PRINT g_dash
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#        SKIP 2 LINE
#      END IF
#
#END REPORT
#No.FUN-860061---------------end
 
FUNCTION i1022_get_gae(p_aag1,p_i)
   DEFINE    l_temp         LIKE type_file.chr1000,  #No.FUN-680098     VARCHAR(100)          
             l_gae04        LIKE gae_file.gae04,                    
             p_i            LIKE type_file.num10,    #No.FUN-680098     INTEGER
             p_aag1         LIKE aag_file.aag151     
 
   LET l_temp = 'aag151_'
 
   IF p_aag1='1' THEN
      LET l_temp = l_temp,'1'
   END IF
   IF p_aag1='2' THEN
      LET l_temp = l_temp,'2'
   END IF
   IF p_aag1='3' THEN
      LET l_temp = l_temp,'3'
   END IF
   SELECT gae04 INTO l_gae04 FROM gae_file
    WHERE gae01='agli1022' AND gae02=l_temp
      AND gae03=g_lang AND gae11='N'
 
   RETURN l_gae04
 
END FUNCTION
 
FUNCTION i1022_chk_aag()
  DEFINE l_aag    ARRAY[10] OF RECORD
             aag  LIKE aag_file.aag15
                  END RECORD,
         l_n1    LIKE type_file.num10,  #No.FUN-680098 INTEGER 
         l_n2    LIKE type_file.num10   #No.FUN-680098 INTEGER 
  
  LET l_aag[1].aag = g_aag[l_ac].aag15
  LET l_aag[2].aag = g_aag[l_ac].aag16
  LET l_aag[3].aag = g_aag[l_ac].aag17
  LET l_aag[4].aag = g_aag[l_ac].aag18
  LET l_aag[5].aag = g_aag[l_ac].aag31
  LET l_aag[6].aag = g_aag[l_ac].aag32
  LET l_aag[7].aag = g_aag[l_ac].aag33
  LET l_aag[8].aag = g_aag[l_ac].aag34
  LET l_aag[9].aag = g_aag[l_ac].aag35
  LET l_aag[10].aag = g_aag[l_ac].aag36
 
#NO.TQC-640007 start--
  IF l_aag[1].aag IS NOT NULL AND 
     l_aag[2].aag IS NOT NULL AND 
     l_aag[3].aag IS NOT NULL AND 
     l_aag[4].aag IS NOT NULL AND 
     l_aag[5].aag IS NOT NULL AND 
     l_aag[6].aag IS NOT NULL AND 
     l_aag[7].aag IS NOT NULL AND 
     l_aag[8].aag IS NOT NULL AND 
     l_aag[9].aag IS NOT NULL AND 
     l_aag[10].aag IS NOT NULL THEN 
#NO.TQC-640007 end--
     LET g_errno = ''
     FOR l_n1 = 1 TO (g_aaz.aaz88 - 1)
        FOR l_n2 = l_n1+1 TO g_aaz.aaz88
           IF l_aag[l_n1].aag = l_aag[l_n2].aag THEN
               LET g_errno = 'agl-046'
               CALL cl_err(l_aag[l_n1].aag,g_errno,1)
               RETURN
           END IF
       END FOR
     END FOR
#FUN-B50105   ---start   Add
     FOR l_n1 = 5 TO (g_aaz.aaz125 - 1)
        FOR l_n2 = l_n1+1 TO g_aaz.aaz125
           IF l_aag[l_n1].aag = l_aag[l_n2].aag THEN
               LET g_errno = 'agl-046'
               CALL cl_err(l_aag[l_n1].aag,g_errno,1)
               RETURN
           END IF
       END FOR
     END FOR
#FUN-B50105   ---end     Add
  END IF  #NO.TQC-640007 
END FUNCTION
#FUN-870144         
         
#------------------------------No.CHI-B70041---------------------start
#str CHI-910038 add
#FUNCTION i1022_chk_abb(p_aag00,p_aag01)
#  DEFINE p_aag00   LIKE aag_file.aag00,
#         p_aag01   LIKE aag_file.aag01,
#         l_cnt     LIKE type_file.num5
#
#  LET g_errno = ''
#  LET l_cnt = 0
#  SELECT COUNT(*) INTO l_cnt FROM abb_file              
#   WHERE abb00 = p_aag00
#     AND abb03 = p_aag01
#  IF l_cnt > 0 THEN
#     LET g_errno = 'agl-237'  #此科目已有傳票使用,不可修改異動碼類型代號!
#  END IF 
#  RETURN
#
#END FUNCTION
#end CHI-910038 add
#------------------------------No.CHI-B70041---------------------end
#FUN-9B0017   ---start
FUNCTION i1022_type()
DEFINE p_row,p_col    LIKE type_file.num5    
DEFINE l_cmd STRING
DEFINE tm RECORD
             aag00 LIKE aag_file.aag00,
             a     LIKE type_file.chr1,
             b     LIKE type_file.chr1, 
             c     LIKE type_file.chr1,                                                                                                
             d     LIKE type_file.chr1
          END RECORD
   LET p_row = 4 LET p_col = 12                                                                                                     
   OPEN WINDOW i1022_a_w AT p_row,p_col                                                                                                
        WITH FORM "agl/42f/agli1022_a"                                                                                                 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)                                                                                     
                                                                                                                                    
   CALL cl_ui_init() 
   LET tm.a='N'
   LET tm.b='N'
   LET tm.c='N'
   LET tm.d='N'

   INPUT BY NAME tm.aag00,tm.a,tm.b,tm.c,tm.d WITHOUT DEFAULTS
      AFTER FIELD aag00
         IF NOT cl_null(tm.aag00) THEN
            SELECT aaa01 FROM aaa_file WHERE aaaacti='Y' AND aaa01=tm.aag00
            IF STATUS THEN 
               CALL cl_err('','agl-043',1)
               LET tm.aag00 = ''
               DISPLAY tm.aag00 TO aag00
               NEXT FIELD aag00
            END IF  
         END IF
    
      AFTER FIELD a
         IF tm.a='Y' THEN
            IF (tm.b ='Y' OR tm.c = 'Y' OR tm.d='Y') THEN
               CALL cl_err('','agl-964',1)    #異動碼5-8一次只能勾選一組
               LET tm.a = 'N'
               DISPLAY tm.a TO a
               NEXT FIELD a
            END IF 
         END IF	

       AFTER FIELD b  
          IF tm.b='Y'  THEN
             IF (tm.a ='Y' OR tm.c = 'Y' OR tm.d='Y') THEN                                                                              
                CALL cl_err('','agl-964',1)   #異動碼5-8一次只能勾選一組
                LET tm.b = 'N'                                                                                                          
                DISPLAY tm.b TO b                                                                                                      
                NEXT FIELD b                                                                                                            
             END IF 
          END IF

      AFTER FIELD c
         IF tm.c='Y' THEN
            IF (tm.a ='Y' OR tm.b = 'Y' OR tm.d='Y') THEN                                                                              
               CALL cl_err('','agl-964',1)    #異動碼5-8一次只能勾選一組
               LET tm.c = 'N'                                                                                                          
               DISPLAY tm.c TO c                                                                                                       
               NEXT FIELD c       
            END IF                                                                                                      
         END IF

      AFTER FIELD d
         IF tm.d='Y' THEN
            IF (tm.a ='Y' OR tm.b = 'Y' OR tm.c='Y') THEN
               CALL cl_err('','agl-964',1)    #異動碼5-8一次只能勾選一組   
               LET tm.d = 'N'
               DISPLAY tm.d TO d
               NEXT FIELD d
            END IF
         END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD (aag00) #帳別
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_aaa"                                                                                        
               LET g_qryparam.default1 = tm.aag00                                                                                       
               CALL cl_create_qry() RETURNING tm.aag00                                                                                  
               DISPLAY tm.aag00  TO aag00                                                                                                
               NEXT FIELD aag00      
            OTHERWISE EXIT CASE
         END CASE 
                                                                                                                                    
   END INPUT   
   IF INT_FLAG THEN 
      CLOSE WINDOW i1022_a_w                                                                                                        
      RETURN                                                                                                                        
   END IF                                                                                                                      
   CASE 
      WHEN tm.a = 'Y'
            LET l_cmd="agli1022_p '",tm.aag00,"' '1'" 
            CALL cl_cmdrun(l_cmd)
      WHEN tm.b = 'Y'
            LET l_cmd="agli1022_p '",tm.aag00,"' '2'"                                                                               
            CALL cl_cmdrun(l_cmd)      
      WHEN tm.c = 'Y'
            LET l_cmd="agli1022_p '",tm.aag00,"' '3'"                                                                               
            CALL cl_cmdrun(l_cmd)    
      WHEN tm.d = 'Y'
            LET l_cmd="agli1022_p '",tm.aag00,"' '4'"                                                                               
            CALL cl_cmdrun(l_cmd)    
   END CASE
   CLOSE WINDOW i1022_a_w    
END FUNCTION
#FUN-9B0017   ---end
#TQC-A90146 
