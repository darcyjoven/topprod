# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi150.4gl
# Descriptions...: 稅別資料維護作業
# Date & Author..: 94/12/07 By Danny 
# Modify.........: 04/09/21 MOD-490344 Kitty Controlp 未加display
#                  04/10/06 MOD-470515 Nicola 加入"相關文件"功能
#                  04/11/03 FUN-4B0020 Nicola 加入"轉EXCEL"功能
#                  05/01/14 FUN-510027 pengu 報表轉XML
#                  05/03/26 MOD-530344 alex 順序改為 gec5,6,4,7,8
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制  
# Modify.........: 05/04/27 MOD-540180 day  大陸版時將gec08隱藏   
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.MOD-580303 05/09/06 By Claire 列印時發票二聯或三聯映對錯誤
# Modify.........: No.MOD-580350 05/10/13 By Rosayu 單身刪除後,再按單身維護一筆資料不會真的新增的資料庫
# Modify.........: No.TQC-5A0051 05/10/17 By Carrier gec06內容僅可為1/2/3
# Modify.........: No.MOD-5A0321 05/10/21 By jackie 大陸版加'X'-不申報及修改報表
# Modify.........: No.FUN-5B0036 05/11/09 By Claire 稅率>0,稅科不可空白
# Modify.........: No.TQC-5C0221 06/01/10 By Tracy  刪除AFTER INPUT內容
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-5B0141 06/06/26 By rainy 銷項格式要可輸入37/37 
# Modify.........: No.FUN-680034 06/08/21 By bnlent 新增"會計科目二"和“科目二名稱”欄位
# Modify.........: No.FUN-680102 06/09/15 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730020 07/03/13 By Carrier 會計科目加帳套
# Modify.........: No.MOD-760030 07/06/07 By Smapmin 大陸版發票種類列印有誤
# Modify.........: No.TQC-750261 07/06/13 By xufeng  查詢時，"會計科目"和"會計科目二"開窗時沒有資料,而實際是有資料的
# Modify.........: No.FUN-760083 07/07/10 By mike報表格式修改為crystal reports
# Modify.........: No.TQC-790139 07/09/26 By chenl    在大陸功能模式下，對申報格式欄位賦值為"XX"
# Modify.........: No.TQC-7A0090 07/10/23 By chenl    單身進入或單身維護過程中換行時，當前行的“科目名稱”欄位的顯示消失
# Modify.........: No.FUN-770040 08/06/04 By Smapmin 發票聯數增加4.收據
# Modify.........: No.MOD-910244 09/02/04 By Sarah 當項別為1.進項輸入的申報格式不是2開頭與XX或項別為2.銷項輸入的申報格式不是3開頭與XX時,提示輸入錯誤訊息
# Modify.........: No.TQC-980047 09/08/06 By lilingyu 新增資料時,"含稅"欄位未設置初始值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70132 10/08/18 By huangtao 添加欄位gecpos
# Modify.........: No.MOD-A90163 10/11/03 By lilingyu 在更改性質欄位值為"2.零稅率"後,將鼠標移至"稅率"欄位,並點擊,程序當掉
# Modify.........: No.FUN-B10052 11/01/24 By lilingyu 科目查詢自動過濾
# Modify.........: No.FUN-B40032 11/04/13 By baogc 添加發票聯欄位項目
# Modify.........: No:FUN-B40071 11/05/03 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B80035 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B70075 11/10/26 By baogc 添加已傳POS否的狀態4.修改中，不下傳
# Modify.........: No:FUN-C90019 12/09/21 By pauline 當稅別為銷項時, 才可在聯數二聯式收銀機發票及三聯式收銀機發票
# Modify.........: No:MOD-CB0135 13/01/29 By Elise AFTER FIELD gec011中判斷新舊值請改用g_gec_o
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_gec           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gec01       LIKE gec_file.gec01,       #稅別碼
        gec02       LIKE gec_file.gec02,       #稅別名稱
        gec011      LIKE gec_file.gec011,      #項別
        gec03       LIKE gec_file.gec03,       #會計科目
        aag02       LIKE aag_file.aag02,       #說明     
        gec031      LIKE gec_file.gec031,      #會計科目二    #No.FUN-680034
        aag021      LIKE aag_file.aag02,       #No.FUN-680034     
        gec05       LIKE gec_file.gec05,       #發票聯數
        gec06       LIKE gec_file.gec06,       #應零免稅
        gec04       LIKE gec_file.gec04,       #稅率
        gec07       LIKE gec_file.gec07,       #含稅否
        gec08       LIKE gec_file.gec08,       #含稅否
        gecacti     LIKE gec_file.gecacti,      #有效否
        gecpos      LIKE gec_file.gecpos                 #No.FUN-A70132   
                    END RECORD,
    g_gec_t         RECORD                     #程式變數 (舊值)
        gec01       LIKE gec_file.gec01,       #稅別碼
        gec02       LIKE gec_file.gec02,       #稅別名稱
        gec011      LIKE gec_file.gec011,      #項別
        gec03       LIKE gec_file.gec03,       #會計科目
        aag02       LIKE aag_file.aag02,       #說明     
        gec031      LIKE gec_file.gec031,      #會計科目二     #No.FUN-680034
        aag021      LIKE aag_file.aag02,       #No.FUN-680034     
        gec05       LIKE gec_file.gec05,       #發票聯數
        gec06       LIKE gec_file.gec06,       #應零免稅
        gec04       LIKE gec_file.gec04,       #稅率
        gec07       LIKE gec_file.gec07,       #含稅否
        gec08       LIKE gec_file.gec08,       #含稅否
        gecacti     LIKE gec_file.gecacti,      #有效否
        gecpos      LIKE gec_file.gecpos                 #No.FUN-A70132 
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,     #No.FUN-680102 SMALLINT,                  #單身筆數
    l_ac            LIKE type_file.num5      #No.FUN-680102 SMALLINT                  #目前處理的ARRAY CNT 
                                              
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10     #No.FUN-680102 INTEGER   
DEFINE g_i          LIKE type_file.num5      #No.FUN-680102 SMALLINT   #count/index for any purpose
DEFINE g_before_input_done   LIKE type_file.num5      #No.FUN-680102 SMALLINT          #判斷是否已執行 Before Input指令
DEFINE g_str                 STRING                   #No.FUN-760083
DEFINE g_edit       LIKE type_file.chr1               #MOD-A90163    
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0081
    DEFINE p_row,p_col   LIKE type_file.num5      #No.FUN-680102 SMALLINT
 
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)           #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET p_row = 2 LET p_col = 15
 
    IF g_aza.aza26 = '2' THEN 
       OPEN WINDOW i150_w AT p_row,p_col WITH FORM "aoo/42f/aooi150_c"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
        CALL cl_set_comp_visible("gec08",FALSE)     #No.MOD-540180 
    ELSE 
       OPEN WINDOW i150_w AT p_row,p_col WITH FORM "aoo/42f/aooi150"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    END IF
    #FUN-A70132 -------------------------start----------------------------
    IF g_aza.aza88 = 'Y' THEN
      CALL cl_set_comp_visible("gecpos",TRUE)
    ELSE
      CALL cl_set_comp_visible("gecpos",FALSE)
    END IF
    #FUN-A70132 -------------------------end-----------------------
    CALL cl_ui_init()
    CALL cl_set_comp_visible("gec031",g_aza.aza63 ='Y')   #No.FUN-680034 
    CALL cl_set_comp_visible("aag021",g_aza.aza63 ='Y')   #No.FUN-680034 
    LET g_wc2 = '1=1'
    CALL i150_b_fill(g_wc2)
 
    CALL i150_menu()
    CLOSE WINDOW i150_w                        #結束畫面
      CALL  cl_used(g_prog,g_time,2)           #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
 
FUNCTION i150_menu()
   WHILE TRUE
      CALL i150_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i150_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i150_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i150_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_gec[l_ac].gec01 IS NOT NULL THEN
                  LET g_doc.column1 = "gec01"
                  LET g_doc.value1 = g_gec[l_ac].gec01
                  LET g_doc.column2 = "gec011"
                  LET g_doc.value2 = g_gec[l_ac].gec011
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gec),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i150_q()
   CALL i150_b_askkey()
END FUNCTION
 
FUNCTION i150_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #No.FUN-680102 SMALLINT,                    #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,      #No.FUN-680102 SMALLINT,                    #檢查重複用
    l_lock_sw       LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),                     #單身鎖住否
    p_cmd           LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),                     #處理狀態
    l_aag02         LIKE aag_file.aag02,         
    l_aag021        LIKE aag_file.aag02,        #No.FUN-680034  
    l_allow_insert  LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(01),                    #可新增否    
    l_allow_delete  LIKE type_file.chr1       #No.FUN-680102 VARCHAR(01)                     #可刪除否  
DEFINE l_gecpos     LIKE gec_file.gecpos      #FUN-B70075 ADD  
    IF s_shut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')  
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
     #MOD-530344
    LET g_forupd_sql = "SELECT gec01,gec02,gec011,gec03,'',gec031,'',gec05,gec06,gec04,gec07,gec08,gecacti,gecpos ",  #No.FUN-680034     #No.FUN-A70132
                       " FROM gec_file  WHERE gec01=? AND gec011=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i150_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gec WITHOUT DEFAULTS FROM s_gec.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec, UNBUFFERED,
                   INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
#No.FUN-570110 --start                                                          
#          LET g_before_input_done = FALSE                                      
#          CALL i150_set_entry(p_cmd)                                           
#          CALL i150_set_no_entry(p_cmd)                                        
#          LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end    
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                     #DEFAULT
            LET l_n  = ARR_COUNT()
            
            LET g_edit = 'Y'                        #MOD-A90163
            
            IF g_rec_b>=l_ac THEN
                #FUN-B70075 Add Begin---
                IF g_aza.aza88 = 'Y' THEN
                   UPDATE gec_file SET gecpos = '4'
                    WHERE gec01 = g_gec[l_ac].gec01
                      AND gec011 = g_gec[l_ac].gec011
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err3("upd","gec_file",g_gec_t.gec01,"",SQLCA.sqlcode,"","",1)
                      LET l_lock_sw = "Y"
                   END IF
                   LET l_gecpos = g_gec[l_ac].gecpos
                   LET g_gec[l_ac].gecpos = '4'
                   DISPLAY BY NAME g_gec[l_ac].gecpos
                END IF
                #FUN-B70075 Add End-----            
                LET p_cmd='u'
                BEGIN WORK
                LET g_gec_t.* = g_gec[l_ac].*  #BACKUP
#No.FUN-570110 --start                                                          
                LET g_before_input_done = FALSE                                 
                CALL i150_set_entry(p_cmd)                                      
                CALL i150_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570110 --end    
 
                OPEN i150_bcl USING g_gec_t.gec01,g_gec_t.gec011 
                IF STATUS THEN
                   CALL cl_err("OPEN i150_bcl:", STATUS, 1)
                   LET l_lock_sw="Y" 
                ELSE
                   FETCH i150_bcl INTO g_gec[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_gec_t.gec01,SQLCA.sqlcode,1)
                   END IF
                END IF  
            
                CALL s_aapact('2',g_aza.aza81,g_gec[l_ac].gec03)   #No.FUN-730020
                             RETURNING g_gec[l_ac].aag02
               #No.TQC-7A0090--begin-- add
                IF NOT cl_null(g_errno) THEN
                   LET g_gec[l_ac].aag02 = ' '    
                END IF
               #No.TQC-7A0090---end--- add
#No.FUN-680034---Begin----
                CALL s_aapact('2',g_aza.aza82,g_gec[l_ac].gec031)  #No.FUN-730020
                             RETURNING g_gec[l_ac].aag021
#No.FUN-680034---End----
                IF NOT cl_null(g_errno) THEN
                #  LET g_gec[l_ac].aag02 = ' '     #No.TQC-7A0090 mark
                   LET g_gec[l_ac].aag021 = ' '    #No.FUN-680034
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                     
           CALL i150_set_entry(p_cmd)                                          
           CALL i150_set_no_entry(p_cmd)                                       
           LET g_before_input_done = TRUE                                      
#No.FUN-570110 --end 
           INITIALIZE g_gec[l_ac].* TO NULL      #900423
           LET g_gec[l_ac].gecacti = 'Y'        #Body default
           LET g_gec[l_ac].gec07 = 'N'     #TQC-980047
#FUN-A70132  ----start----           
           IF g_aza.aza88 = 'Y' THEN
              LET g_gec[l_ac].gecpos = '1' #NO.FUN-B40071
              LET l_gecpos = '1'           #FUN-B70075 ADD
           END IF
#FUN-A70132 -----end-----           
           LET g_gec_t.* = g_gec[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD gec01
 
        AFTER INSERT
           IF INT_FLAG THEN                      #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i150_bcl
              CANCEL INSERT
           END IF   
           #No.TQC-790139--begin-- add
           #若為大陸版功能，則對gec08賦初值為"XX"
           IF g_aza.aza26 = '2' THEN 
              IF cl_null(g_gec[l_ac].gec08) THEN
                 LET g_gec[l_ac].gec08 = 'XX'
              END IF
           END IF 
           #No.TQC-790139---end---
           INSERT INTO gec_file(gec01,gec02,gec011,gec03,gec031,gec04,         #No.FUN-680034
                                gec05,gec06,gec08,gec07,  
                                gecacti,gecuser,gecdate,gecoriu,gecorig,gecpos)        #No.FUN-A70132   
                       VALUES(g_gec[l_ac].gec01,g_gec[l_ac].gec02,
                              g_gec[l_ac].gec011,
                              g_gec[l_ac].gec03,
                              g_gec[l_ac].gec031,g_gec[l_ac].gec04,            #No.FUN-680034 
                              g_gec[l_ac].gec05,g_gec[l_ac].gec06,
                              g_gec[l_ac].gec08,g_gec[l_ac].gec07,
                              g_gec[l_ac].gecacti,g_user,g_today, g_user, g_grup,g_gec[l_ac].gecpos)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_gec[l_ac].gec01,SQLCA.sqlcode,0)   #No.FUN-660131
              CALL cl_err3("ins","gec_file",g_gec[l_ac].gec01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK #test  
           END IF
 
        AFTER FIELD gec011                       #check 編號是否重複
           IF NOT cl_null(g_gec[l_ac].gec011) THEN 
              IF g_gec[l_ac].gec011 NOT MATCHES '[12]' THEN 
                 NEXT FIELD gec011
              END IF 
           END IF
           IF NOT cl_null(g_gec[l_ac].gec01) AND
              NOT cl_null(g_gec[l_ac].gec011) THEN 
              #MOD-CB0135 add start -----
              IF g_gec[l_ac].gec011 = '1' AND g_aza.aza26 <> '2' THEN
                 IF g_gec[l_ac].gec05 MATCHES '[56]' THEN
                    CALL cl_err('','aoo-171',0)
                    NEXT FIELD gec011
                 END IF
              END IF
              #MOD-CB0135 add end   -----
              IF g_gec[l_ac].gec01 != g_gec_t.gec01 OR
                 g_gec[l_ac].gec011!= g_gec_t.gec011 THEN  
                 SELECT count(*) INTO l_n FROM gec_file
                     WHERE gec01 = g_gec[l_ac].gec01
                       AND gec011= g_gec[l_ac].gec011
                 IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_gec[l_ac].gec01 = g_gec_t.gec01
                     LET g_gec[l_ac].gec011= g_gec_t.gec011
                     NEXT FIELD gec01
                 END IF
                #FUN-C90019 add START
                 #MOD-CB0135 mark start -----
                 #IF g_gec[l_ac].gec011 = '1' AND g_aza.aza26 <> '2' THEN
                 #   IF g_gec[l_ac].gec05 MATCHES '[56]' THEN
                 #      CALL cl_err('','aoo-171',0)
                 #      NEXT FIELD gec011
                 #   END IF
                 #END IF
                 #MOD-CB0135 mark end   -----
                #FUN-C90019 add END
              END IF
           END IF

	      AFTER FIELD gec03
           IF NOT cl_null(g_gec[l_ac].gec03) THEN 
                 LET g_errno = ' '
                 CALL s_aapact('2',g_aza.aza81,g_gec[l_ac].gec03) RETURNING l_aag02  #No.FUN-730020
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_gec[l_ac].gec03,g_errno,0)
#FUN-B10052 --begin--                    
#                   LET g_gec[l_ac].gec03  = g_gec_t.gec03 
                    CALL cl_init_qry_var()
                    LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2')  AND aag01 LIKE '",g_gec[l_ac].gec03 CLIPPED,"%'"
                    LET g_qryparam.form ="q_aag" 
                    LET g_qryparam.default1 =g_gec[l_ac].gec03 
                    LET g_qryparam.arg1 = g_aza.aza81 
                    LET g_qryparam.construct = 'N'
                    CALL cl_create_qry() RETURNING g_gec[l_ac].gec03 
                    DISPLAY BY NAME g_gec[l_ac].gec03                     
#FUN-B10052 --end--
                    NEXT FIELD gec03  
                 ELSE 
                    LET g_gec[l_ac].aag02 = l_aag02
                 END IF
           END IF
           LET g_gec_t.gec03  = g_gec[l_ac].gec03 
 
#No.FUN-680034----Begin----
       AFTER FIELD gec031                                                                                                           
           IF NOT cl_null(g_gec[l_ac].gec031) THEN
              LET g_errno = ' '                                                                                                 
              CALL s_aapact('2',g_aza.aza82,g_gec[l_ac].gec031) RETURNING l_aag021   #No.FUN-730020 
              IF NOT cl_null(g_errno) THEN                                                                                       
                 CALL cl_err(g_gec[l_ac].gec031,g_errno,0)                                                                       
#FUN-B10052 --begin--
#                LET g_gec[l_ac].gec031  = g_gec_t.gec031                                                                       
                CALL cl_init_qry_var()  
                LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag01 LIKE '",g_gec[l_ac].gec031 CLIPPED,"%'"                                             
                LET g_qryparam.form ="q_aag"  
                LET g_qryparam.default1 =g_gec[l_ac].gec031
                LET g_qryparam.arg1 = g_aza.aza82
                LET g_qryparam.construct = 'N'
                CALL cl_create_qry() RETURNING g_gec[l_ac].gec031                                                                    
                DISPLAY BY NAME g_gec[l_ac].gec031                  
#FUN-B10052 --end--                 
                 NEXT FIELD gec031                                                                                               
              ELSE                                                                                                              
                 LET g_gec[l_ac].aag021 = l_aag021                                                                                
              END IF                                                                                                            
           END IF                                                                                                                  
           LET g_gec_t.gec031  = g_gec[l_ac].gec031  
#No.FUN-680034----End----
 
        #FUN-5B0036-begin
        AFTER FIELD gec04
           IF g_gec[l_ac].gec04 <> 0 THEN
              IF cl_null(g_gec[l_ac].gec03) THEN
                 CALL cl_err(g_gec[l_ac].gec03,g_errno,0)
                 NEXT FIELD gec03
              END IF
           END IF
        #FUN-5B0036-end

	AFTER FIELD gec05
           IF NOT cl_null(g_gec[l_ac].gec05) THEN
              #modify by danny 020326 #A011
              IF g_aza.aza26 = '2' THEN   #大陸版
                 IF (g_gec[l_ac].gec011= '1' AND 
                     g_gec[l_ac].gec05 NOT MATCHES '[ATWZSNGX]') OR   #No.MOD-5A0321
                    (g_gec[l_ac].gec011= '2' AND 
                     g_gec[l_ac].gec05 NOT MATCHES '[ABC]') THEN
                     LET g_gec[l_ac].gec05 = g_gec_t.gec05
                     NEXT FIELD gec05
                 END IF
              ELSE
                 #IF g_gec[l_ac].gec05 NOT MATCHES '[023X]' THEN    #FUN-770040
              #  IF g_gec[l_ac].gec05 NOT MATCHES '[023X4]' THEN    #FUN-770040  #FUN-B40032 MARK
                 IF g_gec[l_ac].gec05 NOT MATCHES '[023X4567]' THEN              #FUN-B40032 ADD
                    LET g_gec[l_ac].gec05 = g_gec_t.gec05
                    NEXT FIELD gec05
                 END IF
                #FUN-C90019 add START
                 IF g_gec[l_ac].gec011 = '1' THEN
                    IF g_gec[l_ac].gec05 MATCHES '[56]' THEN
                       CALL cl_err('','aoo-171',0)
                       NEXT FIELD gec05
                    END IF
                 END IF
                #FUN-C90019 add END
              END IF
           END IF 
 
 #       #MOD-530344
        BEFORE FIELD gec06
           CALL i150_set_entry(p_cmd)
 
	AFTER FIELD gec06
           #No.TQC-5A0051  --begin
           IF NOT cl_null(g_gec[l_ac].gec06) THEN
              IF g_gec[l_ac].gec06 NOT MATCHES '[123]'THEN
                 LET g_gec[l_ac].gec06 = g_gec_t.gec06
                 NEXT FIELD gec06
              END IF
           END IF
           #No.TQC-5A0051  --end  
           CALL i150_set_no_entry(p_cmd)
#MOD-A90163 --begin--
           IF g_edit = 'N' THEN 
              NEXT FIELD gecacti 
           END IF 
#MOD-A90163 --end--           
 
        AFTER FIELD gec07
           IF NOT cl_null(g_gec[l_ac].gec07) THEN
              IF g_gec[l_ac].gec07 NOT MATCHES '[YN]' THEN
                 LET g_gec[l_ac].gec07 = g_gec_t.gec07
                 NEXT FIELD gec07
              END IF
              IF g_gec[l_ac].gec05='2' AND g_gec[l_ac].gec08!='28' THEN
                 IF g_gec[l_ac].gec07 != 'Y' THEN
                    CALL cl_err(g_gec[l_ac].gec05,'mfg2703',0)
                    NEXT FIELD gec07
                 END IF
              END IF
           END IF
 
        AFTER FIELD gec08
           IF NOT cl_null(g_gec[l_ac].gec08) THEN
              IF g_gec[l_ac].gec011= '1' THEN
                 IF g_gec[l_ac].gec08 != '21' AND g_gec[l_ac].gec08 != '22' AND
                    g_gec[l_ac].gec08 != '23' AND g_gec[l_ac].gec08 != '24' AND
                    g_gec[l_ac].gec08 != '25' AND g_gec[l_ac].gec08 != '26' AND
                    g_gec[l_ac].gec08 != '27' AND g_gec[l_ac].gec08 != '28' AND
                    g_gec[l_ac].gec08 != '29' AND g_gec[l_ac].gec08 != 'XX' THEN  #no:7393
                    LET g_gec[l_ac].gec08 = g_gec_t.gec08
                    CALL cl_err("",'aoo-165', 1)   #MOD-910244 add
                    NEXT FIELD gec08
                 END IF
              END IF
              IF g_gec[l_ac].gec011 = '2' THEN 
                 IF g_gec[l_ac].gec08 != '31' AND g_gec[l_ac].gec08 != '32' AND
                    g_gec[l_ac].gec08 != '33' AND g_gec[l_ac].gec08 != '34' AND
                    g_gec[l_ac].gec08 != '35' AND g_gec[l_ac].gec08 != '36' AND
                    g_gec[l_ac].gec08 != '37' AND g_gec[l_ac].gec08 != '38' AND  #FUN-5B0141 add
                    g_gec[l_ac].gec08 != 'XX' THEN
                    LET g_gec[l_ac].gec08 = g_gec_t.gec08
                    CALL cl_err("",'aoo-166', 1)   #MOD-910244 add
                    NEXT FIELD gec08
                 END IF
              END IF
           END IF
 
        AFTER FIELD gecacti
           IF NOT cl_null(g_gec[l_ac].gecacti) THEN 
            IF g_gec[l_ac].gecacti NOT MATCHES '[YN]' THEN  
               LET g_gec[l_ac].gecacti = g_gec_t.gecacti
               NEXT FIELD gecacti
            END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_gec_t.gec01 IS NOT NULL THEN
                INITIALIZE g_doc.* TO NULL                 #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "gec01"                #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_gec[l_ac].gec01       #No.FUN-9B0098 10/02/24
                LET g_doc.column2 = "gec011"               #No.FUN-9B0098 10/02/24
                LET g_doc.value2 = g_gec[l_ac].gec011      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                               #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                #FUN-A70132 -------------------------start------------------
                IF g_aza.aza88 = 'Y' THEN
                  #FUN-B40071 --START--
                   #IF g_gec[l_ac].gecacti = 'Y' THEN
                   #   CALL cl_err("",'art-648',0) #NO.FUN-B40071                      
                   #   CANCEL DELETE 
                   #END IF
                   #IF g_gec[l_ac].gecacti = 'N' THEN                     
                   #   IF  g_gec[l_ac].gecpos = 'Y' THEN
                   #      
                   #   END IF
                   #   IF  g_gec[l_ac].gecpos = 'N' THEN
                   #       CALL cl_err("",'art-648',0)
                   #       CANCEL DELETE 
                   #   END IF                     
                   #END IF
                  #IF NOT ((g_gec[l_ac].gecpos='3' AND g_gec[l_ac].gecacti='N') #FUN-B70075 MARK
                  #           OR (g_gec[l_ac].gecpos='1'))  THEN                #FUN-B70075 MARK
                  #IF NOT ((l_gecpos = '3' AND g_gec[l_ac].gecacti='N')         #FUN-B70075
                   IF NOT ((l_gecpos = '3' AND g_gec_t.gecacti='N')             #FUN-B70075 Mod By shi
                              OR (l_gecpos = '1')) THEN                         #FUN-B70075 ADD                                    
                      CALL cl_err('','apc-139',0)            
                      CANCEL DELETE
                   END IF  
                   
                  #FUN-B40071 --END--
                END IF                 #FUN-A70132   add
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                #FUN-A70132 ---------------------------end------------------
                DELETE FROM gec_file WHERE gec01 = g_gec_t.gec01
                                       AND gec011= g_gec_t.gec011
                                                            
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_gec_t.gec01,SQLCA.sqlcode,0)   #No.FUN-660131
                    CALL cl_err3("del","gec_file",g_gec_t.gec01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2 
                MESSAGE "Delete OK" #MOD-580350
                CLOSE i150_bcl #MOD-580350
                COMMIT WORK
            END IF
#No.TQC-5C0221 --start--
{
        AFTER INPUT
            IF g_gec[l_ac].gec01 != g_gec_t.gec01 OR
               g_gec[l_ac].gec011!= g_gec_t.gec011 OR
               (g_gec[l_ac].gec01 IS NOT NULL AND g_gec_t.gec01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM gec_file
                    WHERE gec01 = g_gec[l_ac].gec01
                      AND gec011= g_gec[l_ac].gec011
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_gec[l_ac].gec01 = g_gec_t.gec01
                    LET g_gec[l_ac].gec011= g_gec_t.gec011
                    NEXT FIELD gec01
                END IF
            END IF
}       
#No.TQC-5C0221 --end--
        ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gec[l_ac].* = g_gec_t.*
             CLOSE i150_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF 
#FUN-A70132  ----start----           
         IF g_aza.aza88 = 'Y' THEN
           #FUN-B40071 --START--
            #LET g_gec[l_ac].gecpos = 'N'
           #IF g_gec[l_ac].gecpos <> '1' THEN   #FUN-B70075 MARK
            IF l_gecpos <> '1' THEN             #FUN-B70075 ADD
               LET g_gec[l_ac].gecpos = '2'
            ELSE                                #FUN-B70075 ADD
               LET g_gec[l_ac].gecpos = '1'     #FUN-B70075 ADD
            END IF
           #FUN-B40071 --END--
         END IF
#FUN-A70132 -----end-----   
          IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_gec[l_ac].gec01,-263,1)
              LET g_gec[l_ac].* = g_gec_t.*
          ELSE 
              UPDATE gec_file
                 SET gec01=g_gec[l_ac].gec01,gec011=g_gec[l_ac].gec011,
                     gec02=g_gec[l_ac].gec02,
                     gec03=g_gec[l_ac].gec03,gec031=g_gec[l_ac].gec031,                 #No.FUN-680034
                     gec04=g_gec[l_ac].gec04,gec05=g_gec[l_ac].gec05,
                     gec06=g_gec[l_ac].gec06,gec07=g_gec[l_ac].gec07,
                     gec08=g_gec[l_ac].gec08,
                     gecacti=g_gec[l_ac].gecacti,gecmodu=g_user,
                     gecdate=g_today,gecpos =g_gec[l_ac].gecpos                           #FUN-A70132
               WHERE gec01= g_gec_t.gec01
                 AND gec011= g_gec_t.gec011
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_gec[l_ac].gec01,SQLCA.sqlcode,0)   #No.FUN-660131
                CALL cl_err3("upd","gec_file",g_gec_t.gec01,g_gec_t.gec011,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                LET g_gec[l_ac].* = g_gec_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK 
             END IF
           END IF
 
        AFTER ROW
           LET l_ac =ARR_CURR()
          #LET l_ac_t=l_ac                 #FUN-D40030 Mark
           IF INT_FLAG THEN                       #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_gec[l_ac].* = g_gec_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_gec.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i150_bcl
              ROLLBACK WORK
              
              #FUN-B70075 Begin---
              IF p_cmd='u' THEN
                 IF g_aza.aza88 = 'Y' THEN
                    UPDATE gec_file SET gecpos = l_gecpos
                     WHERE gec01 = g_gec[l_ac].gec01 AND gec011 = g_gec[l_ac].gec011
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       CALL cl_err3("upd","gec_file",g_gec_t.gec01,"",SQLCA.sqlcode,"","",1)
                    END IF
                    LET g_gec[l_ac].gecpos = l_gecpos
                    DISPLAY BY NAME g_gec[l_ac].gecpos
                 END IF
              END IF
              #FUN-B70075 End-----              
              EXIT INPUT
           END IF
           LET l_ac_t=l_ac                 #FUN-D40030 Add
           #LET g_gec_t.* = g_gec[l_ac].*          # 900423 #MOD-580350 mark
 
        ON ACTION CONTROLN
           CALL i150_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
           IF INFIELD(gec01) AND l_ac > 1 THEN
              LET g_gec[l_ac].* = g_gec[l_ac-1].*
              NEXT FIELD gec01
           END IF
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(gec03)               #會計科目
                CALL cl_init_qry_var()
                LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') "
                LET g_qryparam.form ="q_aag" 
                LET g_qryparam.default1 =g_gec[l_ac].gec03 
                LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730020
                CALL cl_create_qry() RETURNING g_gec[l_ac].gec03 
#                CALL FGL_DIALOG_SETBUFFER( g_gec[l_ac].gec03 )
                 DISPLAY BY NAME g_gec[l_ac].gec03        #No.MOD-490344
                NEXT FIELD gec03
#No.FUN-680034----Begin----
               WHEN INFIELD(gec031)               #會計科目二                                                                          
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') "                                             
                LET g_qryparam.form ="q_aag"                                                                                        
                LET g_qryparam.default1 =g_gec[l_ac].gec031                                                                          
                LET g_qryparam.arg1 = g_aza.aza82  #No.FUN-730020
                CALL cl_create_qry() RETURNING g_gec[l_ac].gec031                                                                    
                 DISPLAY BY NAME g_gec[l_ac].gec031                                                              
                NEXT FIELD gec031
#No.FUN-680034----End----      
                OTHERWISE EXIT CASE
           END CASE
 
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
 
    CLOSE i150_bcl
 
END FUNCTION
 
FUNCTION i150_b_askkey()
    CLEAR FORM
   CALL g_gec.clear()
    CONSTRUCT g_wc2 ON gec01,gec02,gec011,gec03,gec031,gec05,gec06,gec04,             #No.FUN-680034
                       gec07,gec08,gecacti,gecpos                                     #No.FUN-A70132    
                  FROM s_gec[1].gec01,s_gec[1].gec02,s_gec[1].gec011,s_gec[1].gec03,s_gec[1].gec031,   #No.FUN-680034  
                       s_gec[1].gec05,s_gec[1].gec06,
                       s_gec[1].gec04,s_gec[1].gec07,s_gec[1].gec08,
                       s_gec[1].gecacti,s_gec[1].gecpos                               #No.FUN-A70132  
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
     
      ON ACTION CONTROLP
        CASE
           WHEN INFIELD(gec03)               #會計科目
             CALL cl_init_qry_var()
             #LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') "
             LET g_qryparam.form ="q_aag"
             LET g_qryparam.state = "c"
             LET g_qryparam.arg1 = g_aza.aza81    #No.TQC-750261
             LET g_qryparam.default1 =g_gec[1].gec03
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO gec03
             NEXT FIELD gec03
#No.FUN-680034----Begin---- 
           WHEN INFIELD(gec031)               #會計科目二                                                                              
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.form ="q_aag"                                                                                           
             LET g_qryparam.state = "c"                                                                                             
             LET g_qryparam.arg1 = g_aza.aza82    #No.TQC-750261
             LET g_qryparam.default1 =g_gec[1].gec031                                                                                
             CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                     
             DISPLAY g_qryparam.multiret TO gec031                                                                                   
             NEXT FIELD gec031
#No.FUN-680034----End---- 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('gecuser', 'gecgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_rec_b = 0  #No.FUN-A80022 By shi Add
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i150_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i150_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000   #No.FUN-680102 VARCHAR(200)
    LET g_sql =
               "SELECT gec01,gec02,gec011,gec03,aag02,gec031,'',gec05,gec06,",     #No.FUN-680034
               " gec04,gec07,gec08,gecacti,gecpos ",                               #No.FUN-A70132     
               " FROM gec_file LEFT OUTER JOIN aag_file",
               " ON gec_file.gec03=aag_file.aag01 AND aag_file.aag00='",g_aza.aza81,"'", #單身
               " WHERE ",p_wc2 CLIPPED,  #No.FUN-730020
               " ORDER BY gec01"  #No.FUN-730020
    PREPARE i150_pb FROM g_sql
    DECLARE gec_curs CURSOR FOR i150_pb
 
    CALL g_gec.clear()                      #單身 ARRAY 乾洗 #新增
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gec_curs INTO g_gec[g_cnt].*    #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.FUN-680034----Begin----
        SELECT aag02 INTO g_gec[g_cnt].aag021 
        FROM  aag_file 
        WHERE aag01 =g_gec[g_cnt].gec031
          AND aag00 =g_aza.aza82  #No.FUN-730020
#No.FUN-680034----End---- 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gec.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i150_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gec TO s_gec.*   ATTRIBUTE(COUNT=g_rec_b)
   
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i150_out()
    DEFINE
        l_gec           RECORD LIKE gec_file.*,
        l_i             LIKE type_file.num5,      #No.FUN-680102 SMALLINT,
        l_name          LIKE type_file.chr20,     #No.FUN-680102 VARCHAR(20),                # External(Disk) file name
        l_za05          LIKE type_file.chr1000    #No.FUN-680102 VARCHAR(40)                 #
   
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
    RETURN END IF
 
    CALL cl_wait()
    LET g_str=''                                                 #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog       #No.FUN-760083
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT * FROM gec_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i150_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i150_co                         # SCROLL CURSOR
         CURSOR FOR i150_p1
 
    #CALL cl_outnam('aooi150') RETURNING l_name  #No.FUN-760083
#No.MOD-5A0321 --start--                                                                                                            
    IF g_aza.aza26='2' THEN                      #No.FUN-760083                                                                                    
       #LET g_zaa[37].zaa06='Y'                  #No.FUN-760083
       LET l_name='aooi150'                      #No.FUN-760083                                                                                   
    ELSE                                         #No.FUN-760083                                                                                     
      #LET g_zaa[37].zaa06='N'                   #No.FUN-760083 
      LET l_name='aooi150_1'                      #No.FUN-760083                                                                                 
    END IF                                       #No.FUN-760083                                                                                    
    CALL cl_prt_pos_len()
#No.MOD-5A0321 --end--  
    #START REPORT i150_rep TO l_name             #No.FUN-760083
 
    FOREACH i150_co INTO l_gec.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        #OUTPUT TO REPORT i150_rep(l_gec.*)      #No.FUN-760083
    END FOREACH
    #FINISH REPORT i150_rep                      #No.FUN-760083
    CLOSE i150_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)           #No.FUN-760083
    IF g_zz05='Y' THEN                              #No.FUN-760083 
       CALL cl_wcchp(g_wc2,'gec01,gec02,gec011,gec03,gec031,gec05,gec06,gec04,   #No.FUN-760083                              
                            gec07,gec08,gecacti')   #No.FUN-760083
       RETURNING g_wc2                              #No.FUN-760083
    END IF                                          #No.FUN-760083
    LET g_str=g_wc2                                 #No.FUN-760083
    CALL cl_prt_cs1("aooi150",l_name,g_sql,g_str)   #No.FUN-760083
END FUNCTION
 
#No.FUN-760083 --begin--
{
REPORT i150_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),
        sr RECORD LIKE gec_file.*,
        l_x       LIKE type_file.chr20,     #No.FUN-680102 VARCHAR(20),
        l_chr     LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),
        l_rate    LIKE imd_file.imd01       #No.FUN-680102 VARCHAR(10) 
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.gec01,sr.gec011
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
#No.MOD-5A0321 --start--                                                                                                            
            IF g_aza.aza26='2' THEN                                                                                                 
               LET g_zaa[36].zaa08=g_x[14]                                                                                          
            ELSE                                                                                                                    
               LET g_zaa[36].zaa08=g_x[13]                                                                                          
            END IF                                                                                                                  
#No.MOD-5A0321 --end--    
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
 
            #MOD-580303-mark begin
            #   IF sr.gec05='2' THEN
            #      LET l_x=g_x[9] CLIPPED
            #   ELSE
            #      LET l_x=g_x[10] CLIPPED
            #   END IF
            #MOD-580303-modify begin
         #-----MOD-760030---------
         IF g_aza.aza26 = '2' THEN
            CASE sr.gec05
               WHEN 'A'
                  IF sr.gec011='1' THEN
                     LET l_x=g_x[15] CLIPPED
                  ELSE
                     LET l_x=g_x[23] CLIPPED
                  END IF
               WHEN 'T'
                  LET l_x=g_x[16] CLIPPED
               WHEN 'W'
                  LET l_x=g_x[17] CLIPPED
               WHEN 'Z'
                  LET l_x=g_x[18] CLIPPED
               WHEN 'S'
                  LET l_x=g_x[19] CLIPPED
               WHEN 'N'
                  LET l_x=g_x[20] CLIPPED
               WHEN 'G'
                  LET l_x=g_x[21] CLIPPED
               WHEN 'X'
                  LET l_x=g_x[22] CLIPPED
               WHEN 'B'
                  LET l_x=g_x[24] CLIPPED
               WHEN 'C'
                  LET l_x=g_x[25] CLIPPED
               OTHERWISE
                  LET l_x=''
            END CASE
         ELSE
         #-----END MOD-760030-----
            CASE sr.gec05
               WHEN '0'          #園區收據
                  LET l_x=g_x[11] CLIPPED
               WHEN '2'          #二聯
                  LET l_x=g_x[10] CLIPPED
               WHEN '3'          #三聯
                  LET l_x=g_x[9] CLIPPED
               WHEN 'X'          #不申報
                  LET l_x=g_x[12] CLIPPED
               OTHERWISE
                  LET l_x=''
            END CASE
        END IF   #MOD-760030
            #MOD-580303-end
            
 
            IF sr.gecacti = 'N' 
                THEN PRINT COLUMN g_c[31],'* ';
            END IF
          
            LET l_rate=sr.gec04 USING '##&.&&&','%'  
            PRINT COLUMN g_c[32],sr.gec01,
                  COLUMN g_c[33],sr.gec02,
                  COLUMN g_c[34],sr.gec03,
                  COLUMN g_c[35],l_rate,
                  COLUMN g_c[36],l_x CLIPPED,
                  COLUMN g_c[37],sr.gec08,
                  COLUMN g_c[38],sr.gec07
        ON LAST ROW
            #-----MOD-760030---------
            IF g_zz05 = 'Y' THEN                                                   
               CALL cl_wcchp(g_wc2,'gec01,gec02,gec011,gec03,gec05,gec06,gec04,gec07,gec08')                                             
                    RETURNING g_wc2                                                
               PRINT g_dash[1,g_len]                                               
               CALL cl_prt_pos_wc(g_wc2)                                           
            END IF                                                                 
            #-----END MOD-760030-----
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
END REPORT
}
#No.FUN-760083  --end--
 
 #MOD-530344
 
FUNCTION i150_set_entry(p_cmd)
 
   DEFINE   p_cmd     LIKE type_file.chr1      #No.FUN-680102 VARCHAR(1)
 
     IF INFIELD(gec06) OR (NOT g_before_input_done) THEN
        CALL cl_set_comp_entry("gec04,gec07",TRUE)
     END IF
 
#No.FUN-570110 --start                                                          
   IF p_cmd = 'a' AND ( NOT g_before_input_done )  THEN                         
     CALL cl_set_comp_entry("gec01,gec011",TRUE)                                
   END IF                                                                       
#No.FUN-570110 --end 
END FUNCTION
 
FUNCTION i150_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1      #No.FUN-680102 VARCHAR(1)
 
    IF INFIELD(gec06) OR (NOT g_before_input_done) THEN
       IF l_ac != 0 THEN
          IF g_gec[l_ac].gec06 = "2" OR g_gec[l_ac].gec06 = "3" THEN
             LET g_gec[l_ac].gec04=0
             LET g_gec[l_ac].gec07="N"
             CALL cl_set_comp_entry("gec04,gec07",FALSE)
             LET g_edit = 'N'                  #MOD-A90163
          END IF
       END IF
    END IF
#No.FUN-570110 --start                                                          
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("gec01,gec011",FALSE)                               
   END IF                                                                       
#No.FUN-570110 --end 
 
END FUNCTION

#FUN-B80035
