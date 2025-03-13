# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: ggli009.4gl
# Descriptions...: 合併報表公司基本資料維護
# Date & Author..: 05/08/22 By Dido
# Modify.........: No.FUN-590013 05/09/08 By Dido 檢核更改時不可將[選用TIPTOP]值改為Yes
# Modify.........: No.FUN-590098 05/09/27 By Sarah 帳別(asg05)，改成開窗欄位，可供點選
# Modify.........: No.TQC-590045 05/09/28 By Sarah 若公司為非使用TIPTOP的，將帳別default為00
# Modify.........: No.MOD-5A0272 05/10/20 By Sarah 當修改非TIPTOP公司(asg04=N)的資料時,不應show出-263的錯誤訊息
# Modify.........: No.MOD-5A0333 05/10/31 By Sarah 輸入完非TIPTOP公司(asg04)之後,使用標準set_entry處理欄位可否輸入
# Modify.........: No.TQC-660043 06/06/16 By Smapmin 將資料庫代碼改為營運中心代碼
# Modify.........: No.FUN-660123 06/06/28 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780037 07/07/26 By sherry 報表格式修改為p_query  
# Modify.........: No.MOD-940319 09/04/24 By chenl  調整單身條件判斷位置。
# Modify.........: No.MOD-940322 09/04/24 By chenl  無條件開啟asg01欄位。
# Modify.........: No.FUN-920111 09/05/11 By ve007 asg03放開輸入
# Modify.........: No.TQC-950003 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-960079 09/08/10 By hongmei若為非TIPTOP公,應自動以agls101帳別代入
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960045 09/10/29 by yiting如果非TIPTOP公司,asg03自動帶目前營運中心g_plant
# Modify.........: No:TQC-9C0075 09/12/11 by sherry 做跨資料庫處理時，傳入的dbs參數改為傳plant
# Modify.........: No.FUN-9C0126 09/12/23 By chenmoyan 新增产出符合XBRL上传格式档案1.TXT 2.EXCEL
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-A60025 10/07/27 By sabrina 開窗選取帳別時，若沒經過"營運中心"一欄，則會抓取不到正確的帳別資料
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B70039 11/07/15 by belle 當使用TIPTOP 欄未勾選時, 營運中心代碼應可以不必輸入.
# Modify.........: No:FUN-B70103 11/08/19 By zhangweib 增加「關係人代號對應」功能鍵
# Modify.........: No.TQC-B90023 11/09/13 By xuxz 檢查asg01是否已存在於asa02，asb04中，如存在則不讓刪除該條記錄
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: No.TQC-BC0202 11/12/31 By Carrier 过了asg02字段后,无法返回到该字段修改
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: NO.TQC-D40119 13/07/17 By yangtt 在取合并帐套时，用的是aaz641，应改为大陆版的参数asz01

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-BB0036
#FUN-BA0012
#FUN-BA0006 
DEFINE 
     g_asg          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        asg01       LIKE asg_file.asg01,
        asg02       LIKE asg_file.asg02,
        asg04       LIKE asg_file.asg04,
        asg03       LIKE asg_file.asg03,
        asg05       LIKE asg_file.asg05,
        asg06       LIKE asg_file.asg06,
        asg07       LIKE asg_file.asg07,
        asg08       LIKE asg_file.asg08,
        asg09       LIKE asg_file.asg09        #FUN-9C0126 
                    END RECORD,
    g_asg_t         RECORD               
        asg01       LIKE asg_file.asg01,
        asg02       LIKE asg_file.asg02,
        asg04       LIKE asg_file.asg04,
        asg03       LIKE asg_file.asg03,
        asg05       LIKE asg_file.asg05,
        asg06       LIKE asg_file.asg06,
        asg07       LIKE asg_file.asg07,
        asg08       LIKE asg_file.asg08,
        asg09       LIKE asg_file.asg09        #FUN-9C0126
                    END RECORD,
    g_wc2,g_sql     STRING,  
    g_cmd           LIKE type_file.chr1000,             #No.FUN-680098 VARCHAR(80)
    g_rec_b         LIKE type_file.num5,                #單身筆數                 #No.FUN-680098 smallint
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT      #No.FUN-680098 smallint
    l_plant         DYNAMIC ARRAY OF LIKE azp_file.azp03   #TQC-660043
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done LIKE type_file.num5             #No.FUN-680098  smallint
DEFINE g_cnt               LIKE type_file.num10            #No.FUN-680098  integer
DEFINE g_i                 LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE l_cmd               LIKE type_file.chr1000          #No.FUN-780037
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
DEFINE p_row,p_col   LIKE type_file.num5                  #No.FUN-680098   smallint
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
    
    IF (NOT cl_setup("GGL")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i009_w AT p_row,p_col WITH FORM "ggl/42f/ggli009"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1'
    CALL i009_b_fill(g_wc2)
    CALL i009_menu()
    CLOSE WINDOW i009_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i009_menu()
 
   WHILE TRUE
      CALL i009_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i009_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i009_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
              #No.FUN-780037---Beatk 
              #CALL i009_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                   
               LET l_cmd = 'p_query "ggli009" "',g_wc2 CLIPPED,'"'               
               CALL cl_cmdrun(l_cmd)        
              #No.FUN-780037---End      
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_asg[l_ac].asg01 IS NOT NULL THEN
                  LET g_doc.column1 = "asg01"
                  LET g_doc.value1 = g_asg[l_ac].asg01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asg),'','')
            END IF
#FUN-B70103   ---start   Add
         WHEN "i106"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               LET l_cmd = "agli106 '", g_asg[l_ac].asg01,"'"
               CALL cl_cmdrun(l_cmd)
            END IF
#FUN-B70103   ---end     Add
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i009_q()
   CALL i009_b_askkey()
END FUNCTION
 
FUNCTION i009_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680098 smallint
    l_n             LIKE type_file.num5,                #檢查重複用         #No.FUN-680098 smallint
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680098 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680098 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                #可新增否           #No.FUN-680098 VARCHAR(1)  
    l_allow_delete  LIKE type_file.chr1,                #可刪除否           #No.FUN-680098 VARCHAR(1)  
    l_asa02_count   LIKE type_file.num5,                #判斷asg01是否在asa_file（asa02）中存在   #No.TQC-B90023 smallint
    l_asb04_count   LIKE type_file.num5                 #判斷asg01是否在asb_file（asb04）中存在   #No.TQC-B90023 smallint
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT asg01,asg02,asg04,asg03,asg05,asg06,asg07,asg08,asg09",   #FUN-9C0126 add asg09
                       "  FROM asg_file WHERE asg01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i009_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_asg WITHOUT DEFAULTS FROM s_asg.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
     #No.MOD-940319--beatk--
     ##start MOD-5A0333
     # LET g_before_input_done = FALSE
     # CALL i009_set_entry(p_cmd)
     # CALL i009_set_no_entry(p_cmd)
     # LET g_before_input_done = TRUE
     ##end MOD-5A0333
     #No.MOD-940319---end---
 
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_asg_t.* = g_asg[l_ac].*  #BACKUP
           OPEN i009_bcl USING g_asg_t.asg01
           IF STATUS THEN
              CALL cl_err("OPEN i009_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i009_bcl INTO g_asg[l_ac].* 
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_asg_t.asg01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()     
        END IF
     #No.MOD-940319--beatk--
      #start MOD-5A0333
       LET g_before_input_done = FALSE
       CALL i009_set_entry(p_cmd)
       CALL i009_set_no_entry(p_cmd)
       LET g_before_input_done = TRUE
      #end MOD-5A0333
     #No.MOD-940319---end---
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_asg[l_ac].* TO NULL   
         LET g_asg_t.* = g_asg[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()    
         NEXT FIELD asg01
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i009_bcl
           CANCEL INSERT
        END IF
        INSERT INTO asg_file(asg01,asg02,asg03,asg04,asg05,asg06,asg07,asg08,asg09,asgoriu,asgorig) #FUN-9C0126 add asg09
               VALUES(g_asg[l_ac].asg01,g_asg[l_ac].asg02,g_asg[l_ac].asg03,
               g_asg[l_ac].asg04,g_asg[l_ac].asg05,g_asg[l_ac].asg06,
               g_asg[l_ac].asg07,g_asg[l_ac].asg08,g_asg[l_ac].asg09,g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig #FUN-9C0126 add asg09
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_asg[l_ac].asg01,SQLCA.sqlcode,0)   #No.FUN-660123
           CALL cl_err3("ins","asg_file",g_asg[l_ac].asg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b=g_rec_b+1
           DISPLAY g_rec_b TO FORMONLY.cn2  
        END IF
 
    AFTER FIELD asg01                        #check 編號是否重複
        IF NOT cl_null(g_asg[l_ac].asg01) THEN
           IF g_asg[l_ac].asg01 != g_asg_t.asg01 OR
              g_asg_t.asg01 IS NULL THEN
              SELECT count(*) INTO l_n FROM asg_file
               WHERE asg01 = g_asg[l_ac].asg01
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_asg[l_ac].asg01 = g_asg_t.asg01
                  NEXT FIELD asg01
              END IF
           END IF
        END IF
        IF cl_null(g_asg[l_ac].asg04) THEN   #TQC-590045
           LET g_asg[l_ac].asg04 = 'Y'
        END IF   #TQC-590045
 
   #start MOD-5A0272 mark
   ## FUN-590013 檢核更改時不可將[選用TIPTOP]值改為Yes
   # BEFORE FIELD asg04
   #    IF p_cmd = 'u' AND g_asg[l_ac].asg04 = 'N' THEN
   #       CALL cl_err('',-263,0)
   #       LET g_asg[l_ac].asg04 = g_asg_t.asg04
   #       NEXT FIELD asg06
   #    END IF
   ## FUN-590013 End
   #end MOD-5A0272 mark
 
   #start MOD-5A0333
    BEFORE FIELD asg04
       CALL i009_set_entry(p_cmd)
   #end MOD-5A0333
 
    AFTER FIELD asg04
       IF NOT cl_null(g_asg[l_ac].asg04) THEN 
          IF g_asg[l_ac].asg04 NOT MATCHES '[YN]' THEN
             NEXT FIELD asg04
          END IF
          IF g_asg[l_ac].asg04 = 'Y' THEN
            #CALL cl_set_comp_entry("asg03",TRUE)    #MOD-5A0333 mark
            #CALL cl_set_comp_entry("asg05",TRUE)    #MOD-5A0333 mark
            #NEXT FIELD asg03                        #No.TQC-BC0202
          ELSE
             #INITIALIZE g_asg[l_ac].asg03 TO NULL   #FUN-960045
            LET g_asg[l_ac].asg03 = g_plant          #FUN-960045 add
            #FUN-960079--mod--str--
           #SELECT aaz641 INTO g_asg[l_ac].asg05 FROM aaz_file WHERE aaz00 = '0'    #TQC-D40119 mark
            SELECT asz01 INTO g_asg[l_ac].asg05 FROM asz_file WHERE asz00 = '0'     #TQC-D40119 add
            IF cl_null(g_asg[l_ac].asg03) THEN 
            #FUN-960079--mod--end
            #start TQC-590045
            #若為非使用TIPTOP的公司，將帳別default為00
            #INITIALIZE g_asg[l_ac].asg05 TO NULL  
             LET g_asg[l_ac].asg05 = '00'
            #end TQC-590045 
            END IF  #FUN-960079
             DISPLAY g_asg[l_ac].asg03 TO asg03 
             DISPLAY g_asg[l_ac].asg05 TO asg05 
             CALL i009_set_no_entry(p_cmd)           #MOD-5A0333
             CALL cl_set_comp_entry("asg03,asg05",TRUE)                #NO.FUN-920111
            #CALL cl_set_comp_entry("asg03",FALSE)   #MOD-5A0333 mark
            #CALL cl_set_comp_entry("asg05",FALSE)   #MOD-5A0333 mark
             #NEXT FIELD asg06
            #NEXT FIELD asg03                     #NO.FUN-920111                        #No.TQC-BC0202
          END IF
       END IF
 
    AFTER FIELD asg03
       IF NOT cl_null(g_asg[l_ac].asg03) THEN 
          SELECT * FROM azp_file
           #WHERE azp03 = g_asg[l_ac].asg03    #TQC-660043
           WHERE azp01 = g_asg[l_ac].asg03    #TQC-660043
          IF STATUS THEN 
              #CALL cl_err(g_asg[l_ac].asg03,'-827',0)   #TQC-660043   
#            CALL cl_err(g_asg[l_ac].asg03,STATUS,0)   #TQC-660043   #No.FUN-660123
             CALL cl_err3("sel","azp_file",g_asg[l_ac].asg03 ,"",STATUS,"","",1)  #No.FUN-660123
             NEXT FIELD asg03
          END IF
       ELSE
          IF g_asg[l_ac].asg04 = 'Y' THEN         #FUN-B70039
          CALL cl_err(g_asg[l_ac].asg03,'afa-091',0)
          NEXT FIELD asg03
          END IF                                  #FUN-B70039
       END IF 
      #NEXT FIELD asg05   #MOD-5A0333 mark
 
       #-----TQC-660043---------
       SELECT azp03 INTO l_plant[l_ac] FROM azp_file 
         WHERE azp01 = g_asg[l_ac].asg03
       #-----END TQC-660043-----
 
    AFTER FIELD asg05
      #IF NOT cl_null(g_asg[l_ac].asg05) THEN
       IF NOT cl_null(g_asg[l_ac].asg05) AND NOT cl_null(g_asg[l_ac].asg03) THEN
          #LET g_sql = "SELECT aaa03 FROM ",g_asg[l_ac].asg03 CLIPPED,".dbo.aaa_file",   #TQC-660043
          #LET g_sql = "SELECT aaa03 FROM ",l_plant[l_ac] CLIPPED,".dbo.aaa_file",   #TQC-660043   #TQC-950003 MARK                     
          #LET g_sql = "SELECT aaa03 FROM ",s_dbstring(l_plant[l_ac]),"aaa_file",   #TQC-950003 ADD  #FUN-A50102
          LET g_sql = "SELECT aaa03 FROM ",cl_get_target_table(g_asg[l_ac].asg03,'aaa_file'),  #FUN-A50102 
                      " WHERE aaa01 = '",g_asg[l_ac].asg05,"' ",
                      "   AND aaaacti = 'Y'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
          CALL cl_parse_qry_sql(g_sql,g_asg[l_ac].asg03) RETURNING g_sql  #FUN-A50102
          PREPARE aaa03_pre FROM g_sql
          DECLARE aaa03_cs CURSOR FOR aaa03_pre
          OPEN aaa03_cs 
          FETCH aaa03_cs INTO g_asg[l_ac].asg06
          IF STATUS THEN 
             CALL cl_err(g_asg[l_ac].asg05,'agl-095',0)   
             NEXT FIELD asg05
          END IF
          DISPLAY BY NAME g_asg[l_ac].asg06 
         #CALL cl_set_comp_entry("asg06",FALSE)   #MOD-5A0333 mark
       ELSE
        #CALL cl_err(g_asg[l_ac].asg05,'afa-091',0)    #FUN-B70039
        #NEXT FIELD asg05			                   #FUN-B70039
        #FUN-B70039--beatk--
         IF g_asg[l_ac].asg04 = 'N' AND cl_null(g_asg[l_ac].asg05) THEN
          CALL cl_err(g_asg[l_ac].asg05,'afa-091',0)
          NEXT FIELD asg05
         ELSE
           LET g_sql = "SELECT aaa03 FROM aaa_file",
                       " WHERE aaa01 = '",g_asg[l_ac].asg05,"' ",
                       "   AND aaaacti = 'Y'"
           PREPARE aaa03_pre_1 FROM g_sql
           DECLARE aaa03_cs_1 CURSOR FOR aaa03_pre_1
           OPEN aaa03_cs_1
           FETCH aaa03_cs_1 INTO g_asg[l_ac].asg06
           IF STATUS THEN
              CALL cl_err(g_asg[l_ac].asg05,'agl-095',0)
              NEXT FIELD asg05
       END IF
           DISPLAY BY NAME g_asg[l_ac].asg06
         END IF
       #FUN-B70039---end---
       END IF
 
    AFTER FIELD asg06
       IF NOT cl_null(g_asg[l_ac].asg06) THEN
          SELECT * FROM azi_file
           WHERE azi01 = g_asg[l_ac].asg06 AND aziacti = 'Y'
          IF SQLCA.sqlcode THEN 
#            CALL cl_err(g_asg[l_ac].asg06,'agl-109',0)   #No.FUN-660123
             CALL cl_err3("sel","azi_file",g_asg[l_ac].asg06,"","agl-109","","",1)  #No.FUN-660123
             NEXT FIELD asg06
          END IF
       END IF
 
    AFTER FIELD asg07
       IF NOT cl_null(g_asg[l_ac].asg07) THEN
          SELECT * FROM azi_file
           WHERE azi01 = g_asg[l_ac].asg07 AND aziacti = 'Y'
          IF SQLCA.sqlcode THEN 
#            CALL cl_err(g_asg[l_ac].asg07,'agl-109',0)   #No.FUN-660123
             CALL cl_err3("sel","azi_file",g_asg[l_ac].asg07,"","agl-109","","",1)  #No.FUN-660123
             NEXT FIELD asg07
          END IF
       END IF
 
     BEFORE DELETE                            #是否取消單身
         IF g_asg_t.asg01 IS NOT NULL THEN
            #-TQC-B90023---add--str----
            LET l_asa02_count = 0
            LET l_asb04_count = 0
            SELECT COUNT(*) INTO l_asa02_count
              FROM asa_file
             WHERE asa02 = g_asg[l_ac].asg01

            SELECT COUNT(*) INTO l_asb04_count
              FROM asb_file
             WHERE asb04 = g_asg[l_ac].asg01
            IF l_asa02_count = 0 AND l_asb04_count = 0 THEN

            #-TQC-B90023---add--end----
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "asg01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_asg[l_ac].asg01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
            DELETE FROM asg_file WHERE asg01 = g_asg_t.asg01
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_asg_t.asg01,SQLCA.sqlcode,0)   #No.FUN-660123
                CALL cl_err3("del","asg_file",g_asg_t.asg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
                CANCEL DELETE
                EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
           #-TQC-B90023---add--str----
            ELSE
               CALL cl_err(g_asg_t.asg01,'agl039',1)
               CANCEL DELETE
               EXIT INPUT
         END IF
          #-TQC-B90023---add--end----
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_asg[l_ac].* = g_asg_t.*
           CLOSE i009_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
            CALL cl_err(g_asg[l_ac].asg01,-263,0)
            LET g_asg[l_ac].* = g_asg_t.*
        ELSE
            UPDATE asg_file SET asg01=g_asg[l_ac].asg01,
                                asg02=g_asg[l_ac].asg02,
                                asg03=g_asg[l_ac].asg03,
                                asg04=g_asg[l_ac].asg04,
                                asg05=g_asg[l_ac].asg05,
                                asg06=g_asg[l_ac].asg06,
                                asg07=g_asg[l_ac].asg07,
                                asg08=g_asg[l_ac].asg08,
                                asg09=g_asg[l_ac].asg09          #FUN-9C0126
             WHERE asg01 = g_asg_t.asg01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_asg[l_ac].asg01,SQLCA.sqlcode,0)   #No.FUN-660123
                CALL cl_err3("upd","asg_file",g_asg_t.asg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
                LET g_asg[l_ac].* = g_asg_t.*
            ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
            END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
       #LET l_ac_t = l_ac                # 新增    #FUN-D30032 Mark
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_asg[l_ac].* = g_asg_t.*
           #FUN-D30032--add--str--
           ELSE
              CALL g_asg.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30032--add--end-- 
           END IF
           CLOSE i009_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         LET l_ac_t = l_ac               # 新增     #FUN-D30032 Add
         CLOSE i009_bcl                # 新增
         COMMIT WORK
 
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(asg03) #資料庫代碼                                             
             CALL cl_init_qry_var()                                         
             #LET g_qryparam.form ="q_azp03"  #TQC-660043                                   
             LET g_qryparam.form ="q_zxy"  #TQC-660043                                   
             LET g_qryparam.arg1 = g_user  #TQC-660043
             LET g_qryparam.default1 = g_asg[l_ac].asg03                          
             CALL cl_create_qry() RETURNING g_asg[l_ac].asg03                     
             DISPLAY BY NAME g_asg[l_ac].asg03                                    
             NEXT FIELD asg03                                               
 
         #start FUN-590098
          WHEN INFIELD(asg05)
             SELECT azp03 INTO l_plant[l_ac] FROM azp_file WHERE azp01=g_asg[l_ac].asg03   #MOD-A60025 add
             CALL q_m_aaa(FALSE,TRUE,g_asg[l_ac].asg03,g_asg[l_ac].asg05)   #TQC-660043 #TQC-9C0075 remark
             #CALL q_m_aaa(FALSE,TRUE,l_plant[l_ac],g_asg[l_ac].asg05)   #TQC-660043  #TQC-9C0075 mark
                  RETURNING g_asg[l_ac].asg05
             DISPLAY BY NAME g_asg[l_ac].asg05                                    
             NEXT FIELD asg05
         #end FUN-590098
 
          WHEN INFIELD(asg06) #記帳幣別                                             
             CALL cl_init_qry_var()                                         
             LET g_qryparam.form ="q_azi"                                   
             LET g_qryparam.default1 = g_asg[l_ac].asg06                          
             CALL cl_create_qry() RETURNING g_asg[l_ac].asg06                     
             DISPLAY BY NAME g_asg[l_ac].asg06                                    
             NEXT FIELD asg06                                               
 
          WHEN INFIELD(asg07) #功能幣別                                             
             CALL cl_init_qry_var()                                         
             LET g_qryparam.form ="q_azi"                                   
             LET g_qryparam.default1 = g_asg[l_ac].asg07                          
             CALL cl_create_qry() RETURNING g_asg[l_ac].asg07                     
             DISPLAY BY NAME g_asg[l_ac].asg07                                    
             NEXT FIELD asg07                                               
 
          OTHERWISE
             EXIT CASE
          END CASE
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(asg01) AND l_ac > 1 THEN
             LET g_asg[l_ac].* = g_asg[l_ac-1].*
             NEXT FIELD asg01
         END IF
 
     ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
         CALL cl_cmdask()
 
     ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()    
 
     ON ACTION help      
        CALL cl_show_help() 
 
     END INPUT
 
    CLOSE i009_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i009_b_askkey()
   CLEAR FORM
   CALL g_asg.clear()
    CONSTRUCT g_wc2 ON asg01,asg02,asg04,asg03,asg05,asg06,asg07,asg08,asg09 #FUN-9C0126 add asg09
         FROM s_asg[1].asg01,s_asg[1].asg02,s_asg[1].asg03,
              s_asg[1].asg04,s_asg[1].asg05,s_asg[1].asg06,
              s_asg[1].asg07,s_asg[1].asg08,s_asg[1].asg09                   #FUN-9C0126 add asg09
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(asg03) #資料庫代碼                                             
             CALL cl_init_qry_var()                                         
             #LET g_qryparam.form ="q_azp03"   #TQC-660043                                  
             LET g_qryparam.form ="q_zxy"   #TQC-660043                                  
             LET g_qryparam.arg1 = g_user  #TQC-660043
             LET g_qryparam.default1 = g_asg[l_ac].asg03                          
             CALL cl_create_qry() RETURNING g_asg[l_ac].asg03                     
             DISPLAY BY NAME g_asg[l_ac].asg03                                    
             NEXT FIELD asg03                                               
 
          #start FUN-590098
           WHEN INFIELD(asg05)
             SELECT azp03 INTO l_plant[l_ac] FROM azp_file WHERE azp01=g_asg[l_ac].asg03   #MOD-A60025 add
             CALL q_m_aaa(TRUE,TRUE,g_asg[l_ac].asg03,g_asg[l_ac].asg05)   #TQC-660043 #TQC-9C0075 remark
             #CALL q_m_aaa(TRUE,TRUE,l_plant[l_ac],g_asg[l_ac].asg05)   #TQC-660043  #TQC-9C0075 MARK
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO asg05                                    
             NEXT FIELD asg05
          #end FUN-590098
 
           WHEN INFIELD(asg06) #記帳幣別                                             
             CALL cl_init_qry_var()                                         
             LET g_qryparam.form ="q_azi"                                   
             LET g_qryparam.default1 = g_asg[l_ac].asg06                          
             CALL cl_create_qry() RETURNING g_asg[l_ac].asg06                     
             DISPLAY BY NAME g_asg[l_ac].asg06                                    
             NEXT FIELD asg06                                               
 
           WHEN INFIELD(asg07) #功能幣別                                             
             CALL cl_init_qry_var()                                         
             LET g_qryparam.form ="q_azi"                                   
             LET g_qryparam.default1 = g_asg[l_ac].asg07                          
             CALL cl_create_qry() RETURNING g_asg[l_ac].asg07                     
             DISPLAY BY NAME g_asg[l_ac].asg07                                    
             NEXT FIELD asg07                                               
 
           OTHERWISE
              EXIT CASE
        END CASE
         
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about       
        CALL cl_about()   
 
     ON ACTION help      
        CALL cl_show_help() 
 
     ON ACTION controlg    
        CALL cl_cmdask()  
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('asguser', 'asggrup') #FUN-980030
 
#No.TQC-710076 -- beatk --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i009_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i009_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(200)
 
    LET g_sql = "SELECT asg01,asg02,asg04,asg03,asg05,asg06,asg07,asg08,asg09",  #FUN-9C0126 add azx09
                " FROM asg_file",
                " WHERE ", p_wc2 CLIPPED,           #單身
                " ORDER BY 1" 
    PREPARE i009_pb FROM g_sql
    DECLARE asg_curs CURSOR FOR i009_pb
 
    CALL g_asg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH asg_curs INTO g_asg[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_asg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i009_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_asg TO s_asg.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
#FUN-B70103   ---start   Add
      ON ACTION i106
         LET g_action_choice="i106"
         EXIT DISPLAY
#FUN-B70103   ---end     Add
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-780037---Beatk
{
FUNCTION i009_out()
    DEFINE
        l_asg           RECORD LIKE asg_file.*,
        l_i             LIKE type_file.num5,                  #No.FUN-680098  smallint
        l_name          LIKE type_file.chr20,                 # External(Disk) file name    #No.FUN-680098 VARCHAR(20)
        l_za05          LIKE za_file.za05                     # #No.FUN-680098 VARCHAR(40)
   
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
      RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM asg_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i009_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i009_co                         # SCROLL CURSOR
        CURSOR FOR i009_p1
 
    CALL cl_outnam('ggli009') RETURNING l_name
    START REPORT i009_rep TO l_name
 
    FOREACH i009_co INTO l_asg.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i009_rep(l_asg.*)
    END FOREACH
 
    FINISH REPORT i009_rep
 
    CLOSE i009_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i009_rep(sr)
    DEFINE
        l_trailer_sw   LIKE type_file.chr1,        #No.FUN-680098   VARCHAR(1)
        sr RECORD LIKE asg_file.*
 
   OUTPUT
       TOP MARGIN g_top_maratk
       LEFT MARGIN g_left_maratk
       BOTTOM MARGIN g_bottom_maratk
       PAGE LENGTH g_page_line
 
    ORDER BY sr.asg01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,
                  g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED   #No.FUN-780037    
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
          PRINT COLUMN g_c[31],sr.asg01,
                COLUMN g_c[32],sr.asg02,
                COLUMN g_c[33],sr.asg03,
                COLUMN g_c[34],sr.asg04,
                COLUMN g_c[35],sr.asg05,
                #No.FUN-780037---Beatk---原報表打印有筆誤，現修正
                #COLUMN g_c[34],sr.asg06,
                #COLUMN g_c[34],sr.asg07,
                #COLUMN g_c[34],sr.asg08
                COLUMN g_c[36],sr.asg06,
                COLUMN g_c[37],sr.asg07,
                COLUMN g_c[38],sr.asg08
                #No.FUN-780037---End
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-780037---End
 
FUNCTION i009_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
  #IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN    #No.MOD-940322
     CALL cl_set_comp_entry("asg01",TRUE)
  #END IF                                                 #No.MOD-940322
 
  #start MOD-5A0333
   IF INFIELD(asg04) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("asg03,asg05",TRUE)
   END IF
  #end MOD-5A0333
END FUNCTION
 
FUNCTION i009_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("asg01",FALSE)
   END IF
 
  #start MOD-5A0333
   IF INFIELD(asg04) OR ( NOT g_before_input_done ) THEN
      IF g_asg[l_ac].asg04 = 'N' THEN
         CALL cl_set_comp_entry("asg03,asg05",FALSE)
      END IF
   END IF
  #end MOD-5A0333
END FUNCTION
