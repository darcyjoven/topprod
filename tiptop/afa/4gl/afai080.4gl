# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afai080.4gl
# Descriptions...: 部門折舊費用科目維護作業
# Date & Author..: 96/07/02 By Sophia
# Modify.........: No.MOD-470515 04/07/26 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-490343 04/09/20 By Wiky 單身刪除(F2),時會出現LOCK住的訊息.但實際並無LOCK之現象
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0019 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-4C0029 04/12/07 By Nicola cl_doc參數傳遞錯誤
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳
# Modify.........: No.FUN-590124 05/10/05 By Dido aag02科目名稱放寬
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/24 By zhuying 多套帳修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-740026 07/04/10 By mike    會計科目加帳套
# Midify.........: No.FUN-740020 07/04/12 By mike    會計科目加帳套
# Midify.........: No.TQC-740093 07/04/12 By atsea   會計科目加帳套
# Midify.........: No.TQC-740093 07/04/18 By sherry  會計科目加帳套Bug修改
# Modify.........: No.FUN-770005 07/07/03 By hongmei 報表格式修改為Crystal Report
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-870046 08/07/18 By xiaofeizhu 增加單身整批產生功能
# Modify.........: No.FUN-8C0074 08/12/17 By xiaofeizhu 整批生成時，科目不再回抓設定檔
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-930149 09/03/13 By lilingyu 執行功能鍵"整批產生",產生出來的哦資料有效否都為NULL
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A40084 10/04/19 By Carrier SQL错误,无法打印
# Modify.........: No.MOD-A70204 10/07/28 By xiaofeizhu 修正整批生成時沒有考慮第二帳套的科目，所以第二帳套的科目無法生成的BUG
# Modify.........: No:MOD-AC0059 10/12/08 By Dido AFTER FIELD fbi01 增加條件判斷  
# Modify.........: No.MOD-AC0286 10/12/24 By chenmoyan 處理btn01~btn20
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-AB0088 11/04/08 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B40004 11/04/13 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No:TQC-B50020 11/05/05 By suncx 抓財簽二時所用到的帳別抓改為抓faa02c
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_fbi           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fbi01       LIKE fbi_file.fbi01, 
        gem02       LIKE gem_file.gem02,
        fbi03       LIKE fbi_file.fbi03,
        fbi02       LIKE fbi_file.fbi02, 
        aag02       LIKE aag_file.aag02,
        fbi021      LIKE fbi_file.fbi021,      #FUN-680028
        aag021      LIKE aag_file.aag02,       #FUN-680028
        fbiacti     LIKE fbi_file.fbiacti        #No.FUN-680070 VARCHAR(1)
                    END RECORD,
    g_fbi_t         RECORD                 #程式變數 (舊值)
        fbi01       LIKE fbi_file.fbi01, 
        gem02       LIKE gem_file.gem02,
        fbi03       LIKE fbi_file.fbi03,
        fbi02       LIKE fbi_file.fbi02, 
        aag02       LIKE aag_file.aag02,
        fbi021      LIKE fbi_file.fbi021,        #FUN-680028
        aag021      LIKE aag_file.aag02,         #FUN-680028
        fbiacti     LIKE fbi_file.fbiacti        #No.FUN-680070 VARCHAR(1)
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570108          #No.FUN-680070 SMALLINT
DEFINE   l_table         STRING       #No.FUN-770005
DEFINE   fab13           LIKE fab_file.fab13            #FUN-8C0074
DEFINE   fab131          LIKE fab_file.fab131           #MOD-A70204
#MOD-AC0286 --Begin
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
#MOD-AC0286 --End
 
MAIN
#DEFINE l_time        LIKE type_file.chr8                  #計算被使用時間       #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-680070 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-770005------Begin 
    LET g_sql = " fbi01.fbi_file.fbi01,",
                " gem02.gem_file.gem02,",
                " fbi03.fbi_file.fbi03,",
                " fbi02.fbi_file.fbi02,",
                " aag02.aag_file.aag02,",
                " fbi021.fbi_file.fbi021,",
                " aag021.aag_file.aag02,",
                " fbiacti.fbi_file.fbiacti"
 
    LET l_table = cl_prt_temptable('afai080',g_sql) CLIPPED                                                               
    IF l_table = -1 THEN EXIT PROGRAM END IF 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   
               " VALUES(?, ?, ?, ?, ?,  ?, ?, ?)"
    PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
    END IF 
#No.FUN-770005------End
 
    CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
      RETURNING g_time                                               #NO.FUN-6A0069
    #-->參數設定(faa20)為  '1' 不可輸入
    IF g_faa.faa20 = '1' THEN 
       CALL cl_err("faa20 = '1'",'afa-314',1)
       EXIT PROGRAM
    END IF
    LET p_row = 4 LET p_col =4
    OPEN WINDOW i080_w AT p_row,p_col  WITH FORM "afa/42f/afai080"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
#FUN-680028----begin---                                                                                                             
 # IF g_aza.aza63 = 'Y' THEN     
   IF g_faa.faa31 = 'Y' THEN     #FUN-AB0088                                                                                                   
      CALL cl_set_comp_visible("fbi021,aag021",TRUE)                                                                                
   ELSE                                                                                                                             
      CALL cl_set_comp_visible("fbi021,aag021",FALSE)                                                                               
   END IF                                                                                                                           
#FUN-680028---end-----
 
    LET g_wc2 = '1=1' CALL i080_b_fill(g_wc2)
    CALL i080_menu()
    CLOSE WINDOW i080_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                                                             #NO.FUN-6A0069
END MAIN
 
FUNCTION i080_menu()
 
   WHILE TRUE
      CALL i080_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i080_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i080_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i080_out()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_fbi[l_ac].fbi01 IS NOT NULL THEN
                  LET g_doc.column1 = "fbi01"
                  LET g_doc.value1 = g_fbi[l_ac].fbi01
                   #-----No.MOD-4C0029-----
                  LET g_doc.column2 = "fbi03"
                  LET g_doc.value2 = g_fbi[l_ac].fbi03
                   #-----No.MOD-4C0029 END-----
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "generate"        #No.FUN-870046 
            CALL i080_g()       #No.FUN-870046           
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fbi),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i080_q()
   CALL i080_b_askkey()
END FUNCTION
 
FUNCTION i080_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #可新增否          #No.FUN-680070 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1                  #可刪除否          #No.FUN-680070 VARCHAR(1)
DEFINE  l_aag05     LIKE aag_file.aag05                  #No.FUN-B40004
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')     
    LET l_allow_delete = cl_detail_input_auth('delete')     
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_fbi.clear() END IF
 
 
    CALL cl_opmsg('b')
                                          
    LET g_forupd_sql = "SELECT fbi01,'',fbi03,fbi02,'',fbi021,'',fbiacti  FROM fbi_file WHERE fbi01= ? AND fbi03= ? FOR UPDATE"                 #FUN-680028 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i080_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_fbi
            WITHOUT DEFAULTS
            FROM s_fbi.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,                
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)        
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fbi_t.* = g_fbi[l_ac].*  #BACKUP
#No.FUN-570108 --start--                                                        
                LET g_before_input_done = FALSE                                 
                CALL i080_set_entry(p_cmd)                                      
                CALL i080_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end--          
                BEGIN WORK
                OPEN i080_bcl USING g_fbi_t.fbi01,g_fbi_t.fbi03
                IF STATUS THEN
                   CALL cl_err("OPEN i080_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"  
                ELSE
                   FETCH i080_bcl INTO g_fbi[l_ac].*
                   IF STATUS THEN
                  #IF SQLCA.sqlcode THEN
                      CALL cl_err(g_fbi_t.fbi01,SQLCA.sqlcode,0)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                 #No.MOD-470545
                CALL i080_fbi01('d') 
                CALL i080_fbi02('d') 
               #CALL i080_fbi021('d',g_aza.aza82)  #No.FUN-740026               #FUN-680028
                CALL i080_fbi021('d',g_faa.faa02c)  #No.FUN-740026               #FUN-680028  #TQC-B50020
                CALL i080_fbi03('d') 
                 #No.MOD-470545 (end)
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            DISPLAY  "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start--                                                        
            LET g_before_input_done = FALSE                                 
            CALL i080_set_entry(p_cmd)                                      
            CALL i080_set_no_entry(p_cmd)                                   
            LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end--          
            INITIALIZE g_fbi[l_ac].* TO NULL      #900423
            LET g_fbi[l_ac].fbiacti = 'Y'         #Body default
            LET g_fbi_t.* = g_fbi[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fbi01
 
        AFTER INSERT    
            DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               INITIALIZE g_fbi[l_ac].* TO NULL      #900423
                DISPLAY g_fbi[l_ac].fbi01 TO fbi01    #No.MOD-490343
               CANCEL INSERT
            END IF       
             IF cl_null(g_fbi[l_ac].fbi01) THEN  #No.MOD-490343
               NEXT FIELD fbi01
            END IF
             IF cl_null(g_fbi[l_ac].fbi03) THEN #No.MOD-490343
               NEXT FIELD fbi03
            END IF                        
            INSERT INTO fbi_file(fbi01,fbi02,fbi021,fbi03,fbiacti,fbiuser,fbidate,fbioriu,fbiorig)               #FUN-680028
            VALUES (g_fbi[l_ac].fbi01,g_fbi[l_ac].fbi02,g_fbi[l_ac].fbi021,g_fbi[l_ac].fbi03,    #FUN-680028 
                    g_fbi[l_ac].fbiacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_fbi[l_ac].fbi01,SQLCA.sqlcode,0)   #No.FUN-660136
               CALL cl_err3("ins","fbi_file",g_fbi[l_ac].fbi01,g_fbi[l_ac].fbi03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        #GENERO 
        # BEFORE FIELD fbi03
        AFTER FIELD fbi01
           IF NOT cl_null(g_fbi[l_ac].fbi01) THEN                                  #MOD-AC0059
              IF g_fbi[l_ac].fbi01 != g_fbi_t.fbi01 OR g_fbi_t.fbi01 IS NULL THEN  #MOD-AC0059
                 CALL i080_fbi01('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fbi[l_ac].fbi01,g_errno,0)
                    LET g_fbi[l_ac].fbi01 = g_fbi_t.fbi01
                    NEXT FIELD fbi01
                 END IF   
              END IF                                                               #MOD-AC0059
           END IF                                                                  #MOD-AC0059 
 
        AFTER FIELD fbi03    #主類別            
          IF NOT cl_null(g_fbi[l_ac].fbi03) THEN      #不可空白
            CALL i080_fbi03('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fbi[l_ac].fbi03,g_errno,0)
               LET g_fbi[l_ac].fbi03 = g_fbi_t.fbi03
               NEXT FIELD fbi03
            END IF   
            IF g_fbi[l_ac].fbi01 != g_fbi_t.fbi01 OR  #check 編號是否重複
               g_fbi[l_ac].fbi03 != g_fbi_t.fbi03 OR  #check 編號是否重複
               (g_fbi[l_ac].fbi01 IS NOT NULL AND g_fbi_t.fbi01 IS NULL) OR
               (g_fbi[l_ac].fbi03 IS NOT NULL AND g_fbi_t.fbi03 IS NULL) 
            THEN SELECT count(*) INTO l_n FROM fbi_file
                    WHERE fbi01 = g_fbi[l_ac].fbi01
                      AND fbi03 = g_fbi[l_ac].fbi03
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fbi[l_ac].fbi01 = g_fbi_t.fbi01
                    LET g_fbi[l_ac].fbi03 = g_fbi_t.fbi03
                    NEXT FIELD fbi01
                END IF
            END IF
          END IF
 
        AFTER FIELD fbi02
          #-MOD-AC0059-add-
           IF g_chkey = 'N' THEN
              CALL i080_fbi01('d') 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fbi[l_ac].fbi01,g_errno,0)
                 NEXT FIELD fbi02
              END IF   
           END IF   
          #-MOD-AC0059-add- 
          IF NOT cl_null(g_fbi[l_ac].fbi02) THEN
            CALL i080_fbi02('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fbi[l_ac].fbi02,g_errno,0)
               #FUN-B10049--begin
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_fbi[l_ac].fbi02  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03='2' AND aagacti='Y' AND aag01 LIKE '",g_fbi[l_ac].fbi02 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_fbi[l_ac].fbi02
               DISPLAY BY NAME g_fbi[l_ac].fbi02                                    
               #LET g_fbi[l_ac].fbi02 = g_fbi_t.fbi02
               #FUN-B10049--end
               NEXT FIELD fbi02
            END IF   
            #No.FUN-B40004  --Begin
            LET l_aag05=''
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01 = g_fbi[l_ac].fbi02
               AND aag00 = g_aza.aza81
            IF l_aag05 = 'Y' THEN
               #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
               IF g_aaz.aaz90 !='Y' THEN
                  LET g_errno = ' '
                  CALL s_chkdept(g_aaz.aaz72,g_fbi[l_ac].fbi02,g_fbi[l_ac].fbi01,g_aza.aza81)
                       RETURNING g_errno
               END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fbi[l_ac].fbi02,g_errno,0)
               DISPLAY BY NAME g_fbi[l_ac].fbi02
               NEXT FIELD fbi02
            END IF
            #No.FUN-B40004  --End
          END IF
  #FUN-680028---begin----  
        AFTER FIELD fbi021
          IF NOT cl_null(g_fbi[l_ac].fbi021) THEN
           #CALL i080_fbi021('a',g_aza.aza82) #No.FUN-740020
            CALL i080_fbi021('a',g_faa.faa02c) #No.FUN-740020  #TQC-B50020
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fbi[l_ac].fbi021,g_errno,0)
               #FUN-B10049--begin
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_fbi[l_ac].fbi021 
               LET g_qryparam.construct = 'N'                
               #LET g_qryparam.arg1 = g_aza.aza82  
               LET g_qryparam.arg1 = g_faa.faa02c  #TQC-B50020 
               LET g_qryparam.where = " aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' AND aagacti='Y' AND aag01 LIKE '",g_fbi[l_ac].fbi021 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_fbi[l_ac].fbi021
               DISPLAY BY NAME g_fbi[l_ac].fbi021                                    
               #LET g_fbi[l_ac].fbi021 = g_fbi_t.fbi021
               #FUN-B10049--end
               NEXT FIELD fbi021
            END IF
            #No.FUN-B40004  --Begin
            LET l_aag05=''
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01 = g_fbi[l_ac].fbi021
               AND aag00 = g_aza.aza81
            IF l_aag05 = 'Y' THEN
               #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心 
               IF g_aaz.aaz90 !='Y' THEN
                  LET g_errno = ' '
                  CALL s_chkdept(g_aaz.aaz72,g_fbi[l_ac].fbi021,g_fbi[l_ac].fbi01,g_aza.aza81)
                       RETURNING g_errno
               END IF 
            END IF 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fbi[l_ac].fbi021,g_errno,0)
               DISPLAY BY NAME g_fbi[l_ac].fbi021
               NEXT FIELD fbi021
            END IF 
            #No.FUN-B40004  --End
          END IF
  #FUN-680028----end-----             
        BEFORE DELETE                            #是否取消單身
            IF g_fbi_t.fbi01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "fbi01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_fbi[l_ac].fbi01      #No.FUN-9B0098 10/02/24
                LET g_doc.column2 = "fbi03"               #No.FUN-9B0098 10/02/24
                LET g_doc.value2 = g_fbi[l_ac].fbi03      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM fbi_file WHERE fbi01 = g_fbi_t.fbi01
                                       AND fbi03 = g_fbi_t.fbi03
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fbi_t.fbi01,SQLCA.sqlcode,0)    #No.FUN-660136
                   CALL cl_err3("del","fbi_file",g_fbi_t.fbi01,g_fbi_t.fbi03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   ROLLBACK WORK
                   CANCEL DELETE
                   EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"      
                CLOSE i080_bcl          
                COMMIT WORK
            END IF
 
        ON ROW CHANGE   
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbi[l_ac].* = g_fbi_t.*
               CLOSE i080_bcl     
               ROLLBACK WORK       
               EXIT INPUT
            END IF
             IF cl_null(g_fbi[l_ac].fbi01) THEN  #No.MOD-490343
               NEXT FIELD fbi01
            END IF
             IF cl_null(g_fbi[l_ac].fbi03) THEN #No.MOD-490343
               NEXT FIELD fbi03
            END IF
            IF l_lock_sw = 'Y' THEN      
               CALL cl_err(g_fbi[l_ac].fbi01,-263,1)    
               LET g_fbi[l_ac].* = g_fbi_t.*      
            ELSE                                 
               UPDATE fbi_file SET 
                      fbi01=g_fbi[l_ac].fbi01,fbi02=g_fbi[l_ac].fbi02,
                      fbi021=g_fbi[l_ac].fbi021,fbi03=g_fbi[l_ac].fbi03,           #FUN-680028
                      fbiacti=g_fbi[l_ac].fbiacti,fbimodu=g_user,fbidate=g_today 
                WHERE fbi01=g_fbi_t.fbi01 AND fbi03=g_fbi_t.fbi03
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_fbi[l_ac].fbi01,SQLCA.sqlcode,0)   #No.FUN-660136
                  CALL cl_err3("upd","fbi_file",g_fbi_t.fbi01,g_fbi_t.fbi03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                  LET g_fbi[l_ac].* = g_fbi_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i080_bcl
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
           DISPLAY "AFTER ROW"
           LET l_ac = ARR_CURR() 
        #  LET l_ac_t = l_ac       #FUN-D30032 mark 
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                LET g_fbi[l_ac].* = g_fbi_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_fbi.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
              END IF
              CLOSE i080_bcl                                                   
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac       #FUN-D30032 add
           CLOSE i080_bcl                                                      
           COMMIT WORK                  
 
        ON ACTION CONTROLN
            CALL i080_b_askkey()
           EXIT INPUT
 
        ON ACTION controlp
           CASE
               WHEN INFIELD(fbi01)    #申請部門
#                   CALL q_gem(10,3,g_fbi[l_ac].fbi01)
#                        RETURNING g_fbi[l_ac].fbi01
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_fbi[l_ac].fbi01
                    CALL cl_create_qry() RETURNING g_fbi[l_ac].fbi01
                     DISPLAY g_fbi[l_ac].fbi01 TO fbi01    #No.MOD-490344
                    NEXT FIELD fbi01
               WHEN INFIELD(fbi03)    #主類別  
#                   CALL q_fab(10,3,g_fbi[l_ac].fbi03) 
#                        RETURNING g_fbi[l_ac].fbi03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_fab"
                    LET g_qryparam.default1 = g_fbi[l_ac].fbi03
                    CALL cl_create_qry() RETURNING g_fbi[l_ac].fbi03
                     DISPLAY g_fbi[l_ac].fbi03 TO fbi03    #No.MOD-490344
                    NEXT FIELD fbi03
               WHEN INFIELD(fbi02)    #資產科目
#                   CALL q_aag(10,3,g_fbi[l_ac].fbi02,'23','2',' ')
#                        RETURNING g_fbi[l_ac].fbi02
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.default1 = g_fbi[l_ac].fbi02
                    LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03='2' "
                    LET g_qryparam.arg1 = g_aza.aza81         #No.FUN-740026 
                    CALL cl_create_qry() RETURNING g_fbi[l_ac].fbi02
                     DISPLAY g_fbi[l_ac].fbi02 TO fbi02    #No.MOD-490344
                    NEXT FIELD fbi02
         #FUN-680028---begin-----
               WHEN INFIELD(fbi021)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.default1 = g_fbi[l_ac].fbi021   
                    LET g_qryparam.where = " aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                    #LET g_qryparam.arg1 = g_aza.aza82         #No.FUN-740026  #No.FUN-740020
                    LET g_qryparam.arg1 = g_faa.faa02c         #No.FUN-740026  #No.FUN-740020  #TQC-B50020
                    CALL cl_create_qry() RETURNING g_fbi[l_ac].fbi021
                    DISPLAY g_fbi[l_ac].fbi021 TO fbi021
                    NEXT FIELD fbi021
         #FUN-680028----end------
               OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fbi01) AND l_ac > 1 THEN
                LET g_fbi[l_ac].* = g_fbi[l_ac-1].*
                LET g_fbi[l_ac].fbi01 = '    '            
                LET g_fbi[l_ac].fbiacti = 'Y'               
                NEXT FIELD fbi01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END INPUT
 
    CLOSE i080_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i080_fbi01(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_gem02    LIKE gem_file.gem02,
          l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO g_fbi[l_ac].gem02,l_gemacti
      FROM gem_file
     WHERE gem01 = g_fbi[l_ac].fbi01
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-038'
                                 LET l_gem02 = NULL
                                 LET l_gemacti = NULL
        WHEN l_gemacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'a' THEN
#      LET g_fbi[l_ac].gem02 = l_gem02
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY g_fbi[l_ac].gem02 TO s_fbi[l_ac].gem02
   END IF
END FUNCTION
   
FUNCTION i080_fbi03(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_fab01    LIKE fab_file.fab01,
          l_fabacti  LIKE fab_file.fabacti
 
    LET g_errno = " "
    SELECT fab01,fabacti INTO l_fab01,l_fabacti
      FROM fab_file
     WHERE fab01=g_fbi[l_ac].fbi03
    CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-045'
                                  LET l_fab01 = NULL
                                  LET l_fabacti = NULL
         WHEN l_fabacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
   
FUNCTION i080_fbi02(p_cmd)
DEFINE  
      l_aagacti  LIKE aag_file.aagacti,
      l_aag02    LIKE aag_file.aag02,
      p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    LET g_errno = " "
    SELECT aag02,aagacti INTO g_fbi[l_ac].aag02,l_aagacti
      FROM aag_file
     WHERE aag01=g_fbi[l_ac].fbi02
       AND aag00=g_aza.aza81        #No.FUN-740026
    CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                  LET l_aag02 = NULL
                                  LET l_aagacti = NULL
         WHEN l_aagacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
    IF p_cmd = 'a' THEN
 #      LET g_fbi[l_ac].aag02 = l_aag02
    END IF                     
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
    END IF
END FUNCTION
#FUN-680028----begin-----
FUNCTION i080_fbi021(p_cmd,p_bookno)  #No.FUN-740020
DEFINE
      l_aagacti        LIKE aag_file.aagacti,
      p_bookno         LIKE aag_file.aag00 ,   #No.FUN-740020
      l_aag021         LIKE aag_file.aag02,
      p_cmd            LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
     LET g_errno = " "
     SELECT aag02,aagacti INTO g_fbi[l_ac].aag021,l_aagacti
       FROM aag_file
      WHERE aag01 = g_fbi[l_ac].fbi021
        AND aag00=p_bookno        #No.FUN-740026 #No.FUN-740020 
     CASE 
         WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-025'
                                   LET l_aag021= NULL
                                   LET l_aagacti = NULL
         WHEN l_aagacti = 'N'      LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF p_cmd = 'a' THEN                                                                                                             
 #      LET g_fbi[l_ac].aag02 = l_aag02                                                                                             
    END IF                                                                                                                          
    IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                         
    END IF
END FUNCTION
#FUN-680028-----end----  
 
FUNCTION i080_b_askkey()
    CLEAR FORM
   CALL g_fbi.clear()
    CONSTRUCT g_wc2 ON fbi01,fbi03,fbi02,fbi021,fbiacti        #FUN-680028
            FROM s_fbi[1].fbi01,s_fbi[1].fbi03,s_fbi[1].fbi02,
                 s_fbi[1].fbi021,s_fbi[1].fbiacti              #FUN-680028  
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
               WHEN INFIELD(fbi01)    #申請部門
#                   CALL q_gem(10,3,g_fbi[1].fbi01)
#                        RETURNING g_fbi[1].fbi01
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_fbi[1].fbi01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_fbi[1].fbi01
                    NEXT FIELD fbi01
               WHEN INFIELD(fbi03)    #主類別  
#                   CALL q_fab(10,3,g_fbi[1].fbi03) 
#                        RETURNING g_fbi[1].fbi03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_fab"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_fbi[1].fbi03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_fbi[1].fbi03
                    NEXT FIELD fbi03
               WHEN INFIELD(fbi02)    #資產科目
#                   CALL q_aag(10,3,g_fbi[1].fbi02,'23','2',' ')
#                        RETURNING g_fbi[1].fbi02
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_fbi[1].fbi02
                    LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03='2' "
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_fbi[1].fbi02
                    NEXT FIELD fbi02
   #FUN-680028---begin----
               WHEN INFIELD(fbi021) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"                                                                                   
                    LET g_qryparam.state = "c"                                                                                      
                    LET g_qryparam.default1 = g_fbi[1].fbi021                                                                        
                    LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03='2' "                                                    
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO s_fbi[1].fbi021                                                                   
                    NEXT FIELD fbi021 
   #FUN-680028----end-----
               OTHERWISE EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('fbiuser', 'fbigrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN 
#       CALL cl_err('',9001,0)
#       LET g_fbi[l_ac].* = g_fbi_t.*
#       LET INT_FLAG = 0 RETURN 
#    END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      CALL cl_err('',9001,0)
      LET g_fbi[l_ac].* = g_fbi_t.*
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i080_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i080_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT fbi01,gem02,fbi03,fbi02,aag02,fbi021,'',fbiacti",
        " FROM fbi_file LEFT OUTER JOIN gem_file ON fbi01=gem_file.gem01 LEFT OUTER JOIN aag_file ON fbi02=aag_file.aag01",
#        " WHERE ", p_wc2 CLIPPED,     #單身    #No.TQC-740093 
#        "   AND fbi01 = gem_file.gem01",                #No.TQC-740093  
        "   AND aag_file.aag00='",g_aza.aza81,"'",        #No.FUN-740026  #No.FUN-740020
 "    WHERE  ", p_wc2 CLIPPED,  #No.TQC-740093
        " ORDER BY fbi01"
    PREPARE i080_pb FROM g_sql
    DECLARE fbi_curs CURSOR FOR i080_pb
 
    CALL g_fbi.clear()   #No.470545
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH fbi_curs INTO g_fbi[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,0)
         EXIT FOREACH
      END IF
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 #FUN-680028---begin----
      SELECT aag02 INTO g_fbi[g_cnt].aag021
        FROM aag_file
       WHERE aag01 = g_fbi[g_cnt].fbi021
        #AND aag00 = g_aza.aza82       #No.FUN-740026                                                     
         AND aag00 = g_faa.faa02c       #No.FUN-740026  #TQC-B50020                                                   
       DISPLAY g_fbi[g_cnt].aag021 TO FORMONLY.aag021  
 #FUN-680028---end------  
      LET g_cnt = g_cnt + 1 
    END FOREACH
    CALL g_fbi.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i080_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fbi TO s_fbi.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
#MOD-AC0286 --Begin
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#MOD-AC0286 --End
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
         
      ON ACTION generate                             #FUN-870046   
         LET g_action_choice="generate"              #FUN-870046
         EXIT DISPLAY                                #FUN-870046      
 
   
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #FUN-810046
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i080_out()
    DEFINE
        l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_name          LIKE type_file.chr20,        # External(Disk) file name #No.FUN-680070 VARCHAR(20)
        l_za05          LIKE za_file.za05,           #No.FUN-680070 VARCHAR(40)
        l_aag02         LIKE aag_file.aag02,         #FUN-680028                #No.FUN-680070 VARCHAR(20)
#FUN-590124
        sr    RECORD 
              fbi01     LIKE fbi_file.fbi01,     #部門代號
              gem02     LIKE gem_file.gem02,
              fbi03     LIKE fbi_file.fbi03,     #折舊科目編號
              fbi02     LIKE fbi_file.fbi02,     #折舊科目編號
              aag02     LIKE aag_file.aag02,
              fbi021    LIKE fbi_file.fbi021,    #FUN-680028
              aag021    LIKE aag_file.aag02,     #FUN-680028
              fbiacti   LIKE fbi_file.fbiacti    #有效碼
#FUN-590124 End
              END RECORD
   
    IF g_wc2 IS NULL THEN
#      CALL cl_err('',-400,0) RETURN END IF
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
   
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    CALL cl_del_data(l_table)        #No.FUN-770005                                          
    #No.TQC-A40084  --Begin
    LET g_sql="SELECT fbi01,gem02,fbi03,fbi02,aag02,fbi021,'',fbiacti", 
              "  FROM fbi_file LEFT OUTER JOIN gem_file ",
              "                     ON fbi01 = gem_file.gem01",
              "                LEFT OUTER JOIN aag_file ",                 
              "                     ON fbi02 = aag_file.aag01",
              "                    AND aag_file.aag00 ='", g_aza.aza81,"'",
              " WHERE ",g_wc2 CLIPPED
    #No.TQC-A40084  --End  

    PREPARE i080_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i080_co                         # SCROLL CURSOR
        CURSOR FOR i080_p1
    
#   CALL cl_outnam('afai080') RETURNING l_name      #No.FUN-770005
#FUN-680028---begin---
 #  IF g_aza.aza63 = 'Y' THEN
    IF g_faa.faa31 = 'Y' THEN     #FUN-AB0088 
       LET g_zaa[36].zaa06 = "N"
       LET g_zaa[37].zaa06 = "N"
    ELSE 
       LET g_zaa[36].zaa06 = "Y"
       LET g_zaa[37].zaa06 = "Y"
    END IF
#   CALL cl_prt_pos_len()        #No.FUN-770005
#FUN-680028----end----
 
#   START REPORT i080_rep TO l_name      #No.FUN-770005   
    FOREACH i080_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,0) 
            EXIT FOREACH
            END IF
  #FUN-680028---begin----
  SELECT aag02 INTO l_aag02 FROM aag_file
         WHERE aag01 = sr.fbi021
         #AND  aag00=g_aza.aza82        #No.FUN-740026 
          AND  aag00=g_faa.faa02c       #No.FUN-740026  #TQC-B50020
           LET sr.aag021 = l_aag02
           LET l_aag02 = NULL
  #FUN-680028----end-----
#No.FUN-770005------Begin
        EXECUTE insert_prep USING
                sr.fbi01,sr.gem02,sr.fbi03,sr.fbi02,
                sr.aag02,sr.fbi021,sr.aag021,sr.fbiacti
#       OUTPUT TO REPORT i080_rep(sr.*)
#No.FUN-770005------End
    END FOREACH
#    FINISH REPORT i080_rep     #No.FUN-770005
 
    CLOSE i080_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)   #No.FUN-770005
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc2,'fbi01,fbi03,fbi02,fbi021,fbiacti')                                 
       RETURNING g_wc2                                                          
    END IF
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('afai080','afai080',g_sql,g_wc2)      #No.FUN-770005
END FUNCTION
#No.FUN-770005------Begin  
{
REPORT i080_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#FUN-590124 
        sr    RECORD 
              fbi01     LIKE fbi_file.fbi01,     #部門代號
              gem02     LIKE gem_file.gem02,
              fbi03     LIKE fbi_file.fbi03,     #資產類別
              fbi02     LIKE fbi_file.fbi02,     #折舊科目編號
              aag02     LIKE aag_file.aag02,
              fbi021    LIKE fbi_file.fbi021,    #FUN-680028
              aag021    LIKE aag_file.aag02,     #FUN-680028
              fbiacti   LIKE fbi_file.fbiacti    #有效碼
#FUN-590124 End
              END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fbi01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]           #FUN-680028
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
          IF sr.fbiacti = 'N' THEN PRINT COLUMN g_c[31],'*' END IF
          
          PRINT COLUMN g_c[31],sr.fbi01,
                COLUMN g_c[32],sr.gem02,
                COLUMN g_c[33],sr.fbi03,
                COLUMN g_c[34],sr.fbi02,
                COLUMN g_c[35],sr.aag02,
                COLUMN g_c[36],sr.fbi021,              #FUN-680028
                COLUMN g_c[37],sr.aag021               #FUN-680028
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-770005------End
 
#No.FUN-570108 --start--                                                        
FUNCTION i080_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                #No.FUN-680070 VARCHAR(01)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("fbi01,fbi03",TRUE)                                 
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i080_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                                #No.FUN-680070 VARCHAR(01)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("fbi01,fbi03",FALSE)                                
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end--
 
#No.FUN-870046--Add-Begin--#            
 FUNCTION i080_g()
   DEFINE l_gem01          LIKE fbi_file.fbi01,              
          l_fab01          LIKE fbi_file.fbi03,
          l_fab13          LIKE fbi_file.fbi02            
             
   DEFINE 
         # l_wc,l_sql       LIKE type_file.chr1000      
          l_wc,l_sql       string            #NO.FUN-910082
   LET fab13 = NULL                                       #FUN-8C0074
   LET fab131 = NULL                                      #MOD-A70204
   
   OPEN WINDOW i080_g_w AT 8,20
     WITH FORM "afa/42f/afai080g"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("afai080g")

#MOD-A70204----begin---                                                                                                             
  #IF g_aza.aza63 = 'Y' THEN      
   IF g_faa.faa31 = 'Y' THEN     #FUN-AB0088                                                                                                  
      CALL cl_set_comp_visible("fab131",TRUE)                                                                                
   ELSE                                                                                                                             
      CALL cl_set_comp_visible("fab131",FALSE)                                                                               
   END IF                                                                                                                           
#MOD-A70204---end-----
 
   CONSTRUCT BY NAME l_wc ON gem01,fab01   
 
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(gem01)    #申請部門
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO gem01
              NEXT FIELD gem01
           WHEN INFIELD(fab01)    #主類別  
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_fab"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO fab01
              NEXT FIELD fab01             
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
               
       ON ACTION qbe_select
         	CALL cl_qbe_select() 
         	
       ON ACTION qbe_save
		      CALL cl_qbe_save()
		      
   END CONSTRUCT
   
   #FUN-8C0074 --Begin--#
   INPUT BY NAME fab13,fab131 WITHOUT DEFAULTS      ##MOD-A70204 Add fab131
   
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(fab13)    #科目
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03='2' "
              LET g_qryparam.arg1 = g_aza.aza81         
              CALL cl_create_qry() RETURNING fab13 
              NEXT FIELD fab13
           #MOD-A70204----begin---   
           WHEN INFIELD(fab131)    #科目二
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03='2' "
             #LET g_qryparam.arg1 = g_aza.aza82         
              LET g_qryparam.arg1 = g_faa.faa02c   #TQC-B50020         
              CALL cl_create_qry() RETURNING fab131 
              NEXT FIELD fab131
           #MOD-A70204----End---                                              
           OTHERWISE
              EXIT CASE
         END CASE
   END INPUT            
   #FUN-8C0074 --End--#   
 
   IF INT_FLAG THEN 
      CLOSE WINDOW i080_g_w 
      LET INT_FLAG = 0
      RETURN 
   END IF
 
   IF NOT cl_sure(16,16) THEN
      CLOSE WINDOW i080_g_w
      RETURN 
   END IF
   
#  LET l_sql="SELECT gem01,fab01,fab13 FROM gem_file,fab_file",                       #FUN-8C0074 Mark
   LET l_sql="SELECT gem01,fab01 FROM gem_file,fab_file",                             #FUN-8C0074     
             " WHERE gemacti='Y' AND fabacti='Y'",
             "   AND ",l_wc CLIPPED
   PREPARE i080_g_p FROM l_sql
   DECLARE i080_g_c CURSOR FOR i080_g_p
 
#  FOREACH i080_g_c INTO l_gem01,l_fab01,l_fab13                                      #FUN-8C0074 Mark
   FOREACH i080_g_c INTO l_gem01,l_fab01                                              #FUN-8C0074     
#     MESSAGE l_gem01 CLIPPED,' ',l_fab01 CLIPPED,' ',l_fab13                         #FUN-8C0074 Mark
      MESSAGE l_gem01 CLIPPED,' ',l_fab01 CLIPPED                                     #FUN-8C0074       
#     INSERT INTO fbi_file (fbi01,fbi02,fbi03) VALUES(l_gem01,l_fab13,l_fab01)        #FUN-8C0074 Mark
#     INSERT INTO fbi_file (fbi01,fbi02,fbi03) VALUES(l_gem01,fab13,l_fab01)          #FUN-8C0074      #MOD-930149 MARK 
      DELETE FROM fbi_file WHERE fbi01 = l_gem01 AND fbi03 = l_fab01                  #MOD-A70204 Add
      INSERT INTO fbi_file (fbi01,fbi02,fbi03,fbi021,fbiacti,fbioriu,fbiorig)         #MOD-930149      #MOD-A70204 Add fbi021
      VALUES(l_gem01,fab13,l_fab01,fab131,'Y', g_user, g_grup)  #MOD-930149   #No.FUN-980030 10/01/04  insert columns oriu, orig #MOD-A70204 Add fab131
      
   END FOREACH
 
   CLOSE WINDOW i080_g_w
 
   CALL i080_b_fill(g_wc2)
   DISPLAY ARRAY g_fbi TO s_fbi.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY 
       EXIT DISPLAY
   END DISPLAY
 
END FUNCTION 
#No.FUN-870046--Add-End--#             
