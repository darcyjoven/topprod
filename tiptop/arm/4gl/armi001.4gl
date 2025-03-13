# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armi001.4gl
# Descriptions...: RMA系統單據性質維護作業
# Date & Author..: 98/03/28 By plum 
# Modify.........: 2004/09/16 hj 修改set_user權限控管處
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-510044 05/01/21 By Mandy 報表轉XML
# Modify.........: No.FUN-560060 05/06/18 By day   單據編號加大
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.TQC-5C0064 05/12/13 By kevin 結束位置調整
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.TQC-660133 06/07/03 By rainy s_xxxslip(),s_smu(),s_smv()中的參數 g_sys 改寫死系統別(ex:AAP)中的參數 g_sys 改寫死系統別(ex:AAP)
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.TQC-670042 06/07/13 By Claire 使用者及部門權限修正
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/08 By ice 修正報表格式錯誤
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.MOD-760032 07/06/07 By Carol oayacti給預設值'Y'
# Modify.........: No.FUN-7C0043 07/12/18 By Sunyanchun   橾老報表改成p_query
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10009 10/01/06 By lilingyu 單身錄入時,"立即打印 自動編號 自動審核 影響呆滯日期"未給default值 
# Modify.........: No.FUN-A10109 10/02/10 By TSD.zeak 取消編碼方式，單據性質改成動態combobox
# Modify.........: No.FUN-A70130 10/08/04 By Huangtao 增加系統別oaysys='arm'
# Modify.........: No.TQC-AB0025 10/12/16 By chenying 替換CURRENT OF i001_bcl寫法
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    m_oay           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oayslip     LIKE oay_file.oayslip,  
        oaydesc     LIKE oay_file.oaydesc, 
        oayauno     LIKE oay_file.oayauno,
        oayconf     LIKE oay_file.oayconf,
        oayprnt     LIKE oay_file.oayprnt,
        #oaydmy6     LIKE oay_file.oaydmy6, #FUN-A10109 
        oaytype     LIKE oay_file.oaytype,
        oay12       LIKE oay_file.oay12
                    END RECORD,
    g_buf           LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(40)
    m_oay_t         RECORD                 #程式變數 (舊值)
        oayslip     LIKE oay_file.oayslip,  
        oaydesc     LIKE oay_file.oaydesc, 
        oayauno     LIKE oay_file.oayauno,
        oayconf     LIKE oay_file.oayconf,
        oayprnt     LIKE oay_file.oayprnt,
        #oaydmy6     LIKE oay_file.oaydmy6, #FUN-A10109
        oaytype     LIKE oay_file.oaytype,
        oay12       LIKE oay_file.oay12
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING 
                                      
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
 
 
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0085
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("ARM")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
 
         RETURNING g_time    #No.FUN-6A0085
    LET p_row = 3 LET p_col = 4 
    OPEN WINDOW i001_w AT p_row,p_col 
         WITH FORM "arm/42f/armi001"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i001_b_fill(g_wc2)
    CALL i001_menu()
    CLOSE WINDOW i001_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
FUNCTION i001_menu()
   DEFINE l_cmd  LIKE type_file.chr1000     #No.FUN-7C0043    add
 
   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN 
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN 
               CALL i001_out()   
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(m_oay),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i001_q()
   CALL s_getgee('armi001',g_lang,'oaytype') #FUN-A10109
   CALL i001_b_askkey()
END FUNCTION
 
FUNCTION i001_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
       l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
       l_allow_insert  LIKE type_file.chr1,                #No.FUN-690010 VARCHAR(1), #可新增否
       l_allow_delete  LIKE type_file.chr1                 #No.FUN-690010 VARCHAR(1)   #可刪除否
DEFINE l_tmp_choice    STRING                 #暫存 g_action_choice
DEFINE l_i          LIKE type_file.num5     #No.FUN-560150      #No.FUN-690010 SMALLINT
DEFINE l_oaysys     LIKE oay_file.oaysys 
    LET g_action_choice = ""
 
    IF s_axmshut(0) THEN CALL cl_err('',9037,0) RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT oayslip,oaydesc,oayauno,oayconf,oayprnt,",
                       #"       oaydmy6,", #FUN-A10109
                       "       oaytype,oay12 ",
                       "  FROM oay_file ",
                       " WHERE oayslip = ? AND oaysys ='arm' FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY m_oay WITHOUT DEFAULTS FROM s_oay.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
        BEFORE INPUT  
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            #NO.FUN-560150 --start--
            CALL cl_set_doctype_format("oayslip")
            #NO.FUN-560150 --end--
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET m_oay_t.* = m_oay[l_ac].*  #BACKUP
#No.FUN-570109 --start                                                                                                              
                LET g_before_input_done = FALSE                                                                                     
                CALL i001_set_entry(p_cmd)                                                                                          
                CALL i001_set_no_entry(p_cmd)                                                                                       
                LET g_before_input_done = TRUE                                                                                      
#No.FUN-570109 --end    
                BEGIN WORK
                OPEN i001_bcl USING m_oay_t.oayslip
                IF STATUS THEN
                   CALL cl_err("OPEN i001_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                END IF
                IF SQLCA.sqlcode THEN
                    CALL cl_err(m_oay_t.oayslip,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
                FETCH i001_bcl INTO m_oay[l_ac].* 
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
           #NEXT FIELD oayslip
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start                                                                                                              
            LET g_before_input_done = FALSE                                                                                         
            CALL i001_set_entry(p_cmd)                                                                                              
            CALL i001_set_no_entry(p_cmd)                                                                                           
            LET g_before_input_done = TRUE                                                                                          
#No.FUN-570109 --end  
            INITIALIZE m_oay[l_ac].* TO NULL      #900423
#TQC-A10009 --begin--
             LET m_oay[l_ac].oayauno = 'Y'
             LET m_oay[l_ac].oayprnt = 'N'
             LET m_oay[l_ac].oayconf = 'N'
             LET m_oay[l_ac].oay12   = 'N'
             DISPLAY BY NAME m_oay[l_ac].oayauno, m_oay[l_ac].oayprnt,
                              m_oay[l_ac].oayconf,m_oay[l_ac].oay12 
#TQC-A10009 --end--
            LET m_oay_t.* = m_oay[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oayslip
 
        AFTER INSERT 
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0) 
               LET INT_FLAG = 0 
               CLOSE i001_bcl
               #CKP
               CANCEL INSERT
            END IF              
            IF m_oay[l_ac].oayslip IS NULL OR m_oay[l_ac].oaytype IS NULL
               THEN  #重要欄位空白,無效NO:6842
               DELETE FROM smu_file WHERE smu01=m_oay[l_ac].oayslip
                                      #AND smu03=g_sys        #TQC-670008 remark
                                      AND upper(smu03)='ARM'  #TQC-670008
               IF SQLCA.sqlcode THEN
#                  CALL cl_err('del smu_file',SQLCA.sqlcode,0)  # FUN-660111
                 CALL cl_err3("del","smu_file",m_oay[l_ac].oayslip,g_sys,SQLCA.sqlcode,"","del smu_file",1) # FUN-660111
               END IF
               DELETE FROM smv_file WHERE smv01=m_oay[l_ac].oayslip
                                      #AND smv03=g_sys        #TQC-670008 remark
                                      AND upper(smv03)='ARM'  #TQC-670008
               IF SQLCA.sqlcode THEN
#                  CALL cl_err('del smv_file',SQLCA.sqlcode,0) # FUN-660111
                 CALL cl_err3("del","smv_file",m_oay[l_ac].oayslip,g_sys,SQLCA.sqlcode,"","del smv_file",1) # FUN-660111
               END IF
               #NO:6842
               INITIALIZE m_oay[l_ac].* TO NULL
            END IF
            INSERT INTO oay_file(oayslip,oaydesc,oayauno,
                                 oayconf,oayprnt,
                                 #oaydmy6, #FUN-A10109
                                 oaytype,oay12,oayacti,oaysys)  #MOD-760032 add oayacti   #FUN-A70130
                          VALUES(m_oay[l_ac].oayslip,m_oay[l_ac].oaydesc,
                                 m_oay[l_ac].oayauno,m_oay[l_ac].oayconf,
                                 m_oay[l_ac].oayprnt,
                                 #m_oay[l_ac].oaydmy6, #FUN-A10109
                                 m_oay[l_ac].oaytype,m_oay[l_ac].oay12,'Y','arm')      #MOD-760032 add 'Y'   #FUN-A70130
            IF SQLCA.sqlcode THEN
   #            CALL cl_err(m_oay[l_ac].oayslip,SQLCA.sqlcode,0) #FUN-660111
              CALL cl_err3("ins","oay_file",m_oay[l_ac].oayslip,"",SQLCA.sqlcode,"","",1) # FUN-660111
               #CKP
               CANCEL INSERT
            ELSE
               #FUN-A10109  ===S===
               CALL s_access_doc('a',m_oay[l_ac].oayauno,m_oay[l_ac].oaytype,
                                 m_oay[l_ac].oayslip,'ARM','Y')
               #FUN-A10109  ===E===
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               COMMIT WORK
            END IF
 
        #FUN-A10109 ===S===
        BEFORE FIELD oaytype
          CALL s_getgee('armi001',g_lang,'oaytype') 
        #FUN-A10109 ===E===

        AFTER FIELD oayslip                        #check 編號是否重複
           IF NOT cl_null(m_oay[l_ac].oayslip) THEN
              IF m_oay[l_ac].oayslip != m_oay_t.oayslip OR
                (NOT cl_null(m_oay[l_ac].oayslip) AND 
                     cl_null(m_oay_t.oayslip)) THEN
            #FUN-A70130 -------------start--------------------         
            #     SELECT count(*) INTO l_n FROM oay_file
            #      WHERE oayslip = m_oay[l_ac].oayslip
            #     IF l_n > 0 THEN
            #        CALL cl_err('',-239,0)
            #        LET m_oay[l_ac].oayslip = m_oay_t.oayslip
            #        NEXT FIELD oayslip
            #     END IF
                 LET l_oaysys = NULL
                  SELECT oaysys INTO l_oaysys FROM oay_file                    
                WHERE oayslip = m_oay[l_ac].oayslip                          
               IF NOT cl_null(l_oaysys) THEN                                  
                  CALL cl_err_msg(m_oay[l_ac].oayslip,'alm-766',l_oaysys CLIPPED,1)
                  LET m_oay[l_ac].oayslip = m_oay_t.oayslip 
                  NEXT FIELD oayslip
               END IF 
            #FUN-A70130--------------------end---------------------      
                 #NO.FUN-560150 --start--
                 FOR l_i = 1 TO g_doc_len
                    IF cl_null(m_oay[l_ac].oayslip[l_i,l_i]) THEN
                       CALL cl_err('','sub-146',0)
                       LET m_oay[l_ac].oayslip = m_oay_t.oayslip
                       NEXT FIELD oayslip
                    END IF
                 END FOR
                 #NO.FUN-560150 --end--
              END IF
              IF m_oay[l_ac].oayslip != m_oay_t.oayslip THEN  #NO:6842
                 UPDATE smv_file  SET smv01=m_oay[l_ac].oayslip
                  WHERE smv01=m_oay_t.oayslip   #NO:單別
                    #AND smv03=g_sys             #NO:系統別 #TQC-670008 remark
                    AND upper(smv03)='ARM'       #NO:系統別 #TQC-670008
                 IF SQLCA.sqlcode THEN
     #               CALL cl_err('UPDATE smv_file',SQLCA.sqlcode,0) #FUN-660111
                   CALL cl_err3("upd","smv_file",m_oay_t.oayslip,g_sys,SQLCA.sqlcode,"","UPDATE smv_file",1) # FUN-660111
                    LET l_ac_t = l_ac
                    EXIT INPUT
                 END IF
                 UPDATE smu_file  SET smu01=m_oay[l_ac].oayslip
                  WHERE smu01=m_oay_t.oayslip   #NO:單別
                    #AND smu03=g_sys             #NO:系統別 #TQC-670008 remark
                    AND upper(smu03)='ARM'       #NO:系統別 #TQC-670008
                 IF SQLCA.sqlcode THEN
     #               CALL cl_err('UPDATE smu_file',SQLCA.sqlcode,0) # FUN-660111
                   CALL cl_err3("upd","smu_file",m_oay_t.oayslip,g_sys,SQLCA.sqlcode,"","UPDATE smu_file",1) # FUN-660111
                    LET l_ac_t = l_ac
                    EXIT INPUT
                 END IF
              END IF
           END IF
 
#No.FUN-560060-begin
#       AFTER FIELD oaydmy6 
#          IF m_oay[l_ac].oaydmy6 NOT MATCHES '[12]' THEN
#             NEXT FIELD oaydmy6
#          END IF
#No.FUN-560060-end  
 
        AFTER FIELD oaytype
          # No.FUN-A10109 10/02/10 
          #IF m_oay[l_ac].oaytype != '70' AND m_oay[l_ac].oaytype != '71' AND 
          #   m_oay[l_ac].oaytype != '72' AND m_oay[l_ac].oaytype != '73' AND 
          #   m_oay[l_ac].oaytype != '74' AND m_oay[l_ac].oaytype != '75' THEN 
          #  #m_oay[l_ac].oaytype != '74' AND m_oay[l_ac].oaytype != '75' AND 
          #  #m_oay[l_ac].oaytype != '76' AND m_oay[l_ac].oaytype != '77' THEN
          #   NEXT FIELD oaytype
          #END IF
 
        BEFORE DELETE                            #是否取消單身
            IF m_oay_t.oayslip IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM oay_file WHERE oayslip = m_oay_t.oayslip AND oaysys ='arm'    #FUN-A70130 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(m_oay_t.oayslip,SQLCA.sqlcode,0)
                   CANCEL DELETE
                END IF
                DELETE FROM smv_file
                 #WHERE smv01 = m_oay_t.oayslip AND smv03=g_sys  #NO:6842 #TQC-670008 remark
                 WHERE smv01 = m_oay_t.oayslip AND upper(smv03)='ARM'      #TQC-670008
                IF SQLCA.sqlcode THEN
     #              CALL cl_err('smv_file',SQLCA.sqlcode,0)  # FUN-660111
                 CALL cl_err3("del","smv_file",m_oay_t.oayslip,g_sys,SQLCA.sqlcode,"","smv_file",1) # FUN-660111
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                DELETE FROM smu_file 
                 #WHERE smu01 = m_oay_t.oayslip AND smu03=g_sys   #NO:6842  #TQC-670008 remark
                 WHERE smu01 = m_oay_t.oayslip AND upper(smu03)='ARM'       #TQC-670008
                IF SQLCA.sqlcode THEN
        #           CALL cl_err('smu_file',SQLCA.sqlcode,0) # FUN- 660111
                CALL cl_err3("del","smu_file",m_oay_t.oayslip,g_sys,SQLCA.sqlcode,"","smu_file",1) # FUN-660111
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                #FUN-A10109  ===S===
                CALL s_access_doc('r','','',m_oay_t.oayslip,'ARM','')
                #FUN-A10109  ===E===
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i001_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0) 
             LET INT_FLAG = 0 
             LET m_oay[l_ac].* = m_oay_t.*
             CLOSE i001_bcl 
             ROLLBACK WORK  
             EXIT INPUT 
          END IF
          IF l_lock_sw = 'Y' THEN 
             CALL cl_err(m_oay[l_ac].oayslip,-263,1) 
             LET m_oay[l_ac].* = m_oay_t.*
          ELSE  
                        UPDATE oay_file SET
                                oayslip=m_oay[l_ac].oayslip,
                                oaydesc=m_oay[l_ac].oaydesc,
                                oayauno=m_oay[l_ac].oayauno,
                                oayconf=m_oay[l_ac].oayconf,
                                oayprnt=m_oay[l_ac].oayprnt,
                                #oaydmy6=m_oay[l_ac].oaydmy6, #FUN-A10109
                                oaytype=m_oay[l_ac].oaytype,
                                oay12=m_oay[l_ac].oay12
#                        WHERE CURRENT OF i001_bcl                  #TQC-AB0025 mark
                         WHERE oayslip = m_oay_t.oayslip            #TQC-AB0025 add
             IF SQLCA.sqlcode THEN
  #              CALL cl_err(m_oay[l_ac].oayslip,SQLCA.sqlcode,0) # FUN-660111
              CALL cl_err3("upd","oay_file",m_oay_t.oayslip,"",SQLCA.sqlcode,"","",1) # FUN-660111
                LET m_oay[l_ac].* = m_oay_t.*
             ELSE
                #FUN-A10109  ===S===
                CALL s_access_doc('u',m_oay[l_ac].oayauno,m_oay[l_ac].oaytype,
                                  m_oay_t.oayslip,'ARM','Y')
                #FUN-A10109 ===E===
                MESSAGE 'UPDATE O.K'
                CLOSE i001_bcl
                COMMIT WORK
             END IF
          END IF
 
        AFTER ROW
          LET l_ac = ARR_CURR()                                               
          IF INT_FLAG THEN                 #900423                            
             CALL cl_err('',9001,0)                                           
             LET INT_FLAG = 0                                                 
             #CKP
             IF p_cmd='u' THEN
                LET m_oay[l_ac].* = m_oay_t.*                                    
            #FUN-D40030--add--str--
             ELSE
                CALL m_oay.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
            #FUN-D40030--add--end--
             END IF
             CLOSE i001_bcl                                                   
             ROLLBACK WORK                                                    
             EXIT INPUT                                                       
          END IF                                                              
          LET l_ac_t = l_ac                                                   
          CLOSE i001_bcl                                                      
          COMMIT WORK            
 
#       ON ACTION CONTROLN
#          CALL i001_b_askkey()
#          EXIT INPUT
 
        ON ACTION set_user #NO:6842
           #TQC-670042-begin-mark
           #CASE
           #   WHEN INFIELD(oayslip)
           #        --#LET m_oay[l_ac].oayslip=fgl_dialog_getbuffer()
           #TQC-670042-end-mark
                    IF NOT cl_null(m_oay[l_ac].oayslip) THEN
                        LET l_tmp_choice=g_action_choice.trim() # MOD-490249
                       LET g_action_choice="set_user"
                       IF cl_chk_act_auth() THEN 
                         #CALL s_smu(m_oay[l_ac].oayslip,g_sys) #TQC-660133 remark 
                          CALL s_smu(m_oay[l_ac].oayslip,"ARM") #TQC-660133
                       END IF
                       LET g_action_choice=l_tmp_choice.trim()
                    ELSE
                       CALL cl_err('','anm-217',0)
                    END IF
           #END CASE   #TQC-670042 mark
 
        ON ACTION set_dept  #NO:6842
           #TQC-670042-begin-mark
           #CASE
           #    WHEN INFIELD(oayslip)
           #         --#LET m_oay[l_ac].oayslip=fgl_dialog_getbuffer()
           #TQC-670042-end-mark
                    IF NOT cl_null(m_oay[l_ac].oayslip) THEN
                        LET l_tmp_choice=g_action_choice.trim() # MOD-490249
                       LET g_action_choice="set_dept"
                       IF cl_chk_act_auth() THEN
                         #CALL s_smv(m_oay[l_ac].oayslip,g_sys)  #TQC-660133 remark 
                          CALL s_smv(m_oay[l_ac].oayslip,"ARM")  #TQC-660133
                       END IF
                       LET g_action_choice=l_tmp_choice.trim()
                    ELSE
                       CALL cl_err('','anm-217',0)
                    END IF
           #END CASE   #TQC-670042 mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(oayslip) AND l_ac > 1 THEN
                LET m_oay[l_ac].* = m_oay[l_ac-1].*
                NEXT FIELD oayslip
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
 
    CLOSE i001_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_b_askkey()
    CLEAR FORM
   CALL m_oay.clear()
    CONSTRUCT g_wc2 ON oayslip,oaydesc,oayauno,oayconf,oayprnt,
                       #oaydmy6, #FUN-A10109 
                       oaytype,oay12
            FROM s_oay[1].oayslip,s_oay[1].oaydesc,s_oay[1].oayauno,
                 s_oay[1].oayconf,s_oay[1].oayprnt,
                #s_oay[1].oaydmy6, #FUN-A10109
                 s_oay[1].oaytype,s_oay[1].oay12
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i001_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i001_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    LET g_sql =
        "SELECT oayslip,oaydesc,oayauno,oayconf,oayprnt,",
        #"       oaydmy6,", #FUN-A10109
        "       oaytype,oay12 ",
        "  FROM oay_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        # FUN-A10109 modify -----add 
        "    AND oaytype IN (SELECT gee02 FROM gee_file ",
        "                     WHERE gee01 = 'ARM'    ",
        "                       AND gee04 = 'armi001' ",
        "                       AND gee03 = '",g_lang CLIPPED ,"')",
        "   AND oaysys = 'arm'",            #FUN-A70130    
        #"   AND oaytype MATCHES '7*' ",    
        # FUN-A10109 modify -----end
        " ORDER BY oaytype,oayslip"
    PREPARE i001_pb FROM g_sql
    DECLARE oay_curs CURSOR FOR i001_pb
 
    CALL m_oay.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH oay_curs INTO m_oay[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    #CKP
    CALL m_oay.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY m_oay TO s_oay.*  ATTRIBUTE(COUNT=g_rec_b) 
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
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
 
    
      ON ACTION exporttoexcel       #FUN-4B0035
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i001_out()
DEFINE l_cmd  LIKE type_file.chr1000     #No.FUN-7C0043    add
#   DEFINE
#       l_oay           RECORD LIKE oay_file.*,
#       l_i             LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#       l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_za05          LIKE type_file.chr1000                #  #No.FUN-690010 VARCHAR(40)
 
    #FUN-7C0043 ---Begin
    IF g_wc2 IS NULL THEN CALL cl_err('',9057,0) RETURN END IF                  
    LET l_cmd = 'p_query "armi001" "',g_wc2 CLIPPED,'"'     #                   
    CALL cl_cmdrun(l_cmd)           
    #FUN-7C0043----End
                                            
#   CALL cl_wait()
#   IF g_wc2 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#   CALL cl_wait()
#   CALL cl_outnam('armi001') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM oay_file ",          # 組合出 SQL 指令
#             " WHERE oaytype MATCHES '7*' ", 
#             "   AND ",g_wc2 CLIPPED
#   PREPARE i001_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i001_co                         # SCROLL CURSOR
#       CURSOR FOR i001_p1
 
#   START REPORT i001_rep TO l_name
 
#   FOREACH i001_co INTO l_oay.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i001_rep(l_oay.*)
#   END FOREACH
 
#   FINISH REPORT i001_rep
 
#   CLOSE i001_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i001_rep(sr)
#   DEFINE
#       l_trailer_sw   LIKE type_file.chr1,          #No.FUN-690010 VARCHAR(1),
#       sr RECORD LIKE oay_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.oaytype,sr.oayslip
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED    #No.TQC-6A0091
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno" 
#           PRINT g_head CLIPPED,pageno_total     
#           #PRINT     #No.TQC-6A0091
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#           PRINT g_dash1 
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.oayslip,
#                 COLUMN g_c[32],sr.oaydesc[1,10],
#                 COLUMN g_c[33],sr.oayauno,
#                 COLUMN g_c[34],sr.oayconf,
#                 COLUMN g_c[35],sr.oayprnt,
#                 COLUMN g_c[36],sr.oaydmy6,
#                 COLUMN g_c[37],sr.oaytype,
#                 COLUMN g_c[38],sr.oay12 
 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0064
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0064
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
                                                                                                                                    
#No.FUN-570109 --start                                                                                                              
FUNCTION i001_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                               #No.FUN-690010 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("oayslip",TRUE)                                                                                         
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i001_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                               #No.FUN-690010 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("oayslip",FALSE)                                                                                        
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-570109 --end     
