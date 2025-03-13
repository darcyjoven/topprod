# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi050.4gl
# Descriptions...: 部門名稱(Multi-line process)
# Date & Author..: 94/12/19 Nick 
# Modify.........: No:7889 03/08/27 By Wiky 可輸入值要check 例如設最大為4 則不可輸入超過4
# Modify.........: No:A109 04/02/20 By Danny  單價/匯率小數位數加大
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4B0060 04/11/25 By Nicola 加入azi10
# Modify.........: No.MOD-510185 05/01/31 By Kitty 修改azi07欄位判斷
# Modify.........: No.FUN-510027 05/02/03 By pengu 報表轉XML
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制  
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6A0090 06/11/07 By baogui  虛線拉長
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-750164 07/05/24 By chenl   增加打印字段，有效否。
# Modify.........: No.FUN-780056 07/06/29 By mike 報表格式修改為p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-C10154 12/02/09 By jt_chen 查詢時先將g_rec_b預設為0
# Modify.........: No.CHI-CA0005 13/03/26 By jt_chen 於資料異動時寫入azo_file
# Modify.........: No.FUN-CA0011 13/03/28 By Elise 異動時，檢查該筆別是否存在axm、apm、ap、ar單據
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_azi           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        azi01       LIKE azi_file.azi01,   #員工編號
        azi02       LIKE azi_file.azi02,   #員工姓名
        azi03       LIKE azi_file.azi03,   #部門編號
        azi04       LIKE azi_file.azi04,   #職稱
        azi05       LIKE azi_file.azi05,
        azi07       LIKE azi_file.azi07,	
        azi10       LIKE azi_file.azi10,   #FUN-4B0060
        aziacti     LIKE azi_file.aziacti  #No.FUN-680102CHAR(1) 
                    END RECORD,
    g_azi_t         RECORD                 #程式變數 (舊值)
        azi01       LIKE azi_file.azi01,   #員工編號
        azi02       LIKE azi_file.azi02,   #員工姓名
        azi03       LIKE azi_file.azi03,   #部門編號
        azi04       LIKE azi_file.azi04,   #職稱
        azi05       LIKE azi_file.azi05,
        azi07       LIKE azi_file.azi07,	
        azi10       LIKE azi_file.azi10,   #FUN-4B0060
        aziacti     LIKE azi_file.aziacti  #No.FUN-680102CHAR(1)  
                    END RECORD,
    g_wc2,g_sql    LIKE type_file.chr1000,       #No.FUN-680102CHAR(300),  
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110         #No.FUN-680102 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0081
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680102 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW i050_w AT p_row,p_col WITH FORM "aoo/42f/aooi050"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i050_b_fill(g_wc2)
    CALL i050_menu()
    CLOSE WINDOW i050_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i050_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   #No.FUN-780056
   WHILE TRUE
      CALL i050_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i050_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i050_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #CALL i050_out()                                          #No.FUN-780056
               IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF               #No.FUN-780056         
               LET l_cmd='p_query "aooi050" "',g_wc2 CLIPPED,'"'          #No.FUN-780056
               CALL cl_cmdrun(l_cmd)                                     #No.FUN-780056
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_azi[l_ac].azi01 IS NOT NULL THEN
                  LET g_doc.column1 = "azi01"
                  LET g_doc.value1 = g_azi[l_ac].azi01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azi),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i050_q()
   CALL i050_b_askkey()
END FUNCTION
 
FUNCTION i050_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
   l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1)               #可新增否
   l_allow_delete  LIKE type_file.chr1            #No.FUN-680102 VARCHAR(1)                #可刪除否
DEFINE   g_msg           LIKE type_file.chr1000              #CHI-CA0005
DEFINE   l_azo06         LIKE azo_file.azo06                 #CHI-CA0005
DEFINE   l_azo05         LIKE azo_file.azo05                 #CHI-CA0005
#FUN-CA0011---add---S
DEFINE   l_cnt,l_cnt2,l_cnt3,
         l_cnt4,l_cnt5,l_cnt6,
         l_cnt7,l_cnt8,l_cnt9,
         l_cnta,l_cntb,l_cntc   LIKE type_file.num10            
#FUN-CA0011---add---E

 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT azi01,azi02,azi03,azi04,azi05,azi07,azi10,aziacti",   #FUN-4B0060
                      "  FROM azi_file WHERE azi01= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i050_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_azi WITHOUT DEFAULTS FROM s_azi.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
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
#No.FUN-570110 --start                                                          
             LET g_before_input_done = FALSE                                    
             CALL i050_set_entry(p_cmd)                                         
             CALL i050_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                     
#No.FUN-570110 --end            
             LET g_azi_t.* = g_azi[l_ac].*  #BACKUP
             OPEN i050_bcl USING g_azi_t.azi01
             IF STATUS THEN
                CALL cl_err("OPEN i050_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i050_bcl INTO g_azi[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_azi_t.azi01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
#No.FUN-570110 --start                                                          
          LET g_before_input_done = FALSE                                       
          CALL i050_set_entry(p_cmd)                                            
          CALL i050_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
#No.FUN-570110 --end    
          INITIALIZE g_azi[l_ac].* TO NULL      #900423
          LET g_azi[l_ac].aziacti = 'Y'       #Body default
          LET g_azi_t.* = g_azi[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD azi01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i050_bcl
             CANCEL INSERT
          END IF
          INSERT INTO azi_file(azi01,azi02,azi03,azi04,azi05,azi07,azi10,aziacti,aziuser,azidate,azioriu,aziorig)   #FUN-4B0060
          VALUES(g_azi[l_ac].azi01,g_azi[l_ac].azi02,g_azi[l_ac].azi03,g_azi[l_ac].azi04,
                 g_azi[l_ac].azi05,g_azi[l_ac].azi07,g_azi[l_ac].azi10,g_azi[l_ac].aziacti,g_user,g_today, g_user, g_grup)   #FUN-4B0060      #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_azi[l_ac].azi01,SQLCA.sqlcode,0)   #No.FUN-660131
             CALL cl_err3("ins","azi_file",g_azi[l_ac].azi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
             CANCEL INSERT
          ELSE
             #CHI-CA0005 -- add start --
             LET g_msg = TIME
             LET l_azo05 = 'azi01:',g_azi[l_ac].azi01
             LET l_azo06 = 'Insert'
             INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
               VALUES ('aooi050',g_user,g_today,g_msg,l_azo05,l_azo06,g_plant,g_legal)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","azo_file","aooi050","",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             END IF
             #CHI-CA0005 -- add end --
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD azi01                        #check 編號是否重複
          IF NOT cl_null(g_azi[l_ac].azi01) THEN
             IF g_azi[l_ac].azi01 != g_azi_t.azi01 OR
                g_azi_t.azi01 IS NULL THEN
                SELECT count(*) INTO l_n FROM azi_file
                 WHERE azi01 = g_azi[l_ac].azi01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_azi[l_ac].azi01 = g_azi_t.azi01
                   NEXT FIELD azi01
                END IF
             END IF
          END IF
       
        AFTER FIELD azi03   #No:7889
            #No.A109
            IF cl_null(g_azi[l_ac].azi03) OR g_azi[l_ac].azi03 > 6 OR g_azi[l_ac].azi03 < 0 THEN
                NEXT FIELD azi03
            END IF          #No:7889
 
        AFTER FIELD azi04   #No:7889
             IF cl_null(g_azi[l_ac].azi04) OR g_azi[l_ac].azi04 > 6 OR g_azi[l_ac].azi04 < 0 THEN       #No.MOD-510185
                NEXT FIELD azi04
            END IF          #No:7889
 
        AFTER FIELD azi05  #No:7889
             IF cl_null(g_azi[l_ac].azi05) OR g_azi[l_ac].azi05 > 6 OR g_azi[l_ac].azi05 < 0 THEN       #No.MOD-510185
                NEXT FIELD azi05
            END IF          #No:7889
 
        AFTER FIELD azi07   #No:7889
             IF cl_null(g_azi[l_ac].azi07) OR g_azi[l_ac].azi07 > 10 OR g_azi[l_ac].azi07 < 0 THEN        #No.MOD-510185
                NEXT FIELD azi07
            END IF          #No:7889
 
       AFTER FIELD aziacti
          IF NOT cl_null(g_azi[l_ac].aziacti) THEN
             IF g_azi[l_ac].aziacti NOT MATCHES '[YN]' THEN 
                LET g_azi[l_ac].aziacti = g_azi_t.aziacti
                NEXT FIELD aziacti
             END IF
          END IF
       		
       BEFORE DELETE                            #是否取消單身
          IF g_azi_t.azi01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "azi01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_azi[l_ac].azi01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM azi_file WHERE azi01 = g_azi_t.azi01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_azi_t.azi01,SQLCA.sqlcode,0)   #No.FUN-660131
                CALL cl_err3("del","azi_file",g_azi_t.azi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                EXIT INPUT
             END IF
             #CHI-CA0005 -- add start --
             LET g_msg = TIME
             LET l_azo05 = 'azi01:',g_azi_t.azi01
             LET l_azo06 = 'Delete'
             INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
               VALUES ('aooi050',g_user,g_today,g_msg,l_azo05,l_azo06,g_plant,g_legal)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","azo_file","aooi050","",SQLCA.sqlcode,"","",1)
                CANCEL DELETE
             END IF
             #CHI-CA0005 -- add end --
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_azi[l_ac].* = g_azi_t.*
             CLOSE i050_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_azi[l_ac].azi01,-263,0)
             LET g_azi[l_ac].* = g_azi_t.*
          ELSE
            #FUN-CA0011---add---S 
             SELECT COUNT(*) INTO l_cnt  FROM oea_file WHERE oea23  = g_azi[l_ac].azi01  #訂單
             SELECT COUNT(*) INTO l_cnt2 FROM oga_file WHERE oga23  = g_azi[l_ac].azi01  #出通單
             SELECT COUNT(*) INTO l_cnt3 FROM pmk_file WHERE pmk22  = g_azi[l_ac].azi01  #請購單
             SELECT COUNT(*) INTO l_cnt4 FROM pmm_file WHERE pmm22  = g_azi[l_ac].azi01  #採購單
             SELECT COUNT(*) INTO l_cnt5 FROM rva_file WHERE rva111 = g_azi[l_ac].azi01  #JIT收貨
             SELECT COUNT(*) INTO l_cnt6 FROM rvu_file WHERE rvu113 = g_azi[l_ac].azi01  #倉退
             SELECT COUNT(*) INTO l_cnt7 FROM apa_file WHERE apa13  = g_azi[l_ac].azi01  #AP
             SELECT COUNT(*) INTO l_cnt8 FROM ala_file WHERE ala20  = g_azi[l_ac].azi01  #AP
             SELECT COUNT(*) INTO l_cnt9 FROM alk_file WHERE alk11  = g_azi[l_ac].azi01  #AP
             SELECT COUNT(*) INTO l_cnta FROM alh_file WHERE alh11  = g_azi[l_ac].azi01  #AP
             SELECT COUNT(*) INTO l_cntb FROM oma_file WHERE oma23  = g_azi[l_ac].azi01  #AR
             SELECT COUNT(*) INTO l_cntc FROM ola_file WHERE ola06  = g_azi[l_ac].azi01  #AR  
             IF (l_cnt>0 OR l_cnt2>0 OR l_cnt3>0 OR l_cnt4>0 OR l_cnt5>0 OR l_cnt6>0
                 OR l_cnt7>0 OR l_cnt8>0 OR l_cnt9>0 OR l_cnta>0 OR l_cntb>0 OR l_cntc>0) THEN 
                IF NOT cl_confirm('aoo1020') THEN 
                   LET g_azi[l_ac].* = g_azi_t.* 
                   ROLLBACK WORK
                   EXIT INPUT 
                END IF
             END IF
            #FUN-CA0011---add---E
             UPDATE azi_file SET azi01=g_azi[l_ac].azi01,
                                 azi02=g_azi[l_ac].azi02,
                                 azi03=g_azi[l_ac].azi03,
                                 azi04=g_azi[l_ac].azi04,
                                 azi05=g_azi[l_ac].azi05,
                                 azi07=g_azi[l_ac].azi07,
                                 azi10=g_azi[l_ac].azi10,   #FUN-4B0060
                                 aziacti=g_azi[l_ac].aziacti,
                                 azimodu=g_user,
                                 azidate=g_today
              WHERE azi01 = g_azi_t.azi01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_azi[l_ac].azi01,SQLCA.sqlcode,0)   #No.FUN-660131
                CALL cl_err3("upd","azi_file",g_azi_t.azi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                LET g_azi[l_ac].* = g_azi_t.*
             ELSE
                #CHI-CA0005 -- add start --
                LET g_msg = TIME
                LET l_azo05 = 'azi01:',g_azi_t.azi01
                LET l_azo06 = 'Update'
                INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
                  VALUES ('aooi050',g_user,g_today,g_msg,l_azo05,l_azo06,g_plant,g_legal)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","azo_file","aooi050","",SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
                #CHI-CA0005 -- add end --
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增   #FUN-D40030 Mark

          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_azi[l_ac].* = g_azi_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_azi.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE i050_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac                       #FUN-D40030 Add 
          CLOSE i050_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(azi01) AND l_ac > 1 THEN
             LET g_azi[l_ac].* = g_azi[l_ac-1].*
             NEXT FIELD azi01
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
 
   CLOSE i050_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i050_b_askkey()
 
   CLEAR FORM
   CALL g_azi.clear()
   CONSTRUCT g_wc2 ON azi01,azi02,azi03,azi04,azi05,azi07,azi10,aziacti   #FUN-4B0060
        FROM s_azi[1].azi01,s_azi[1].azi02,s_azi[1].azi03,s_azi[1].azi04,
             s_azi[1].azi05,s_azi[1].azi07,s_azi[1].azi10,s_azi[1].aziacti   #FUN-4B0060
 
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('aziuser', 'azigrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = 0   #MOD-C10154 add
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   CALL i050_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i050_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      #No.FUN-680102CHAR(200)  
 
    LET g_sql =
        "SELECT azi01,azi02,azi03,azi04,azi05,azi07,azi10,aziacti",   #FUN-4B0060
        " FROM azi_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i050_pb FROM g_sql
    DECLARE azi_curs CURSOR FOR i050_pb
 
    CALL g_azi.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH azi_curs INTO g_azi[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_azi.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i050_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_azi TO s_azi.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         LET l_ac = 1
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
#No.FUN-780056 --str
#FUNCTION i050_out()
#    DEFINE
#        l_azi           RECORD LIKE azi_file.*,
#        l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
#        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
#        l_za05          LIKE za_file.za05             #No.FUN-680102 VARCHAR(40)
#   
#    IF g_wc2 IS NULL THEN 
#    #  CALL cl_err('',-400,0)
#       CALL cl_err('','9057',0)
#       RETURN
#    END IF
#    CALL cl_wait()
##   LET l_name = 'aooi050.out'
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM azi_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc2 CLIPPED
#    PREPARE i050_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i050_co                         # SCROLL CURSOR
#         CURSOR FOR i050_p1
#
#    CALL cl_outnam('aooi050') RETURNING l_name
#    START REPORT i050_rep TO l_name
#
#    FOREACH i050_co INTO l_azi.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i050_rep(l_azi.*)
#    END FOREACH
#
#    FINISH REPORT i050_rep
#
#    CLOSE i050_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i050_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680102CHAR(1) 
#        l_loss1   LIKE aag_file.aag02,
#        l_loss2   LIKE aag_file.aag02,
#        sr RECORD LIKE azi_file.*,
#        l_chr     LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   #No.MOD-580242
#
#    ORDER BY sr.azi01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#
#            PRINT g_dash[1,g_len]
#            PRINT COLUMN (g_c[34]+1),g_x[11]
#            PRINT COLUMN g_c[33],g_dash2[1,g_w[33]+g_w[34]+g_w[35]+g_w[36]+2]      #TQC-6A0090
#            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],
#                           g_x[35],g_x[36],g_x[37],g_x[46]   #No.TQC-750164
#            PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42],
#                           g_x[43],g_x[44],g_x[45]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            #IF sr.aziacti = 'N' THEN PRINT '*'; END IF
#            PRINTX name=D1 COLUMN g_c[31],sr.azi01,
#                  COLUMN g_c[32],sr.azi02,
#                  COLUMN g_c[33],sr.azi03 USING '&    ',
#                  COLUMN g_c[34],sr.azi04 USING '&    ',
#                  COLUMN g_c[35],sr.azi05 USING '&    ',
#                  COLUMN g_c[36],sr.azi07 USING '&  ',
#                  COLUMN g_c[37],sr.azi08,
#                  COLUMN g_c[46],sr.aziacti         #No.TQC-750164
#            PRINTX name=D2 COLUMN g_c[45],sr.azi09
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-780056 -end
 
#No.FUN-570110 --start                                                          
FUNCTION i050_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("azi01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i050_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("azi01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end           
