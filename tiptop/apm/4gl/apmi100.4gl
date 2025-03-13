# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: apmi100.4gl
# Descriptions...: 付款條件 FM
# Date & Author..: 94/11/21 By Roger
# Modify ........: No.+105 010507 by linda add pma12,pma13 票據到期日起算基準
# Modify.........: NO.MOD-470518 BY wiky add cl_doc()功能
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0095 05/01/10 By Mandy 報表轉XML
# Modify.........: NO.FUN-570109 05/07/14 By Trisy key值可更改      
# Modify.........: NO.FUN-570148 05/07/20 By Sarah 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 修改報表寬度結尾位置
# Modify.........: No.MOD-610077 06/01/18 By pengu 單身->右側有ACTION'常用特殊說明"沒有做用
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0090 06/11/01 By baogui 表頭多行空白
# Modify.........: No.TQC-6B0074 06/11/15 By Ray 打開程序單身即應該顯示資料，而不是查詢后才顯示
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-790077 07/09/19 By Carrier 現金拆扣範圍應該為0~100
# Modify.........: No.FUN-820002 08/02/25 By lutingting 報表轉為使用p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9B0043 09/12/30 By Dido 若已存在交易資料則不可刪除 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-B50015 11/05/31 By Smapmin 將pma04隱藏
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
 
    g_pma           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pma01       LIKE pma_file.pma01,   #
        pma11       LIKE pma_file.pma11,   #
        pma02       LIKE pma_file.pma02,   #
        pma03       LIKE pma_file.pma03,   #
        pma09       LIKE pma_file.pma09,   #
        pma08       LIKE pma_file.pma08,   #
        pma12       LIKE pma_file.pma12,   #
        pma13       LIKE pma_file.pma13,   #
        pma10       LIKE pma_file.pma10,   #
        pma04       LIKE pma_file.pma04,   #
        pmaacti     LIKE pma_file.pmaacti  #No.FUN-680136 VARCHAR(1)
                    END RECORD,
    g_pma_t         RECORD                 #程式變數 (舊值)
        pma01       LIKE pma_file.pma01,   #
        pma11       LIKE pma_file.pma11,   #
        pma02       LIKE pma_file.pma02,   #
        pma03       LIKE pma_file.pma03,   #
        pma09       LIKE pma_file.pma09,   #
        pma08       LIKE pma_file.pma08,   #
        pma12       LIKE pma_file.pma12,   #
        pma13       LIKE pma_file.pma13,   #
        pma10       LIKE pma_file.pma10,   #
        pma04       LIKE pma_file.pma04,   #
        pmaacti     LIKE pma_file.pmaacti  #No.FUN-680136 VARCHAR(1) 
                    END RECORD,
#    g_wc,g_sql    VARCHAR(300),  #NO.TQC-630166 MARK
    g_wc,g_sql     STRING,     #NO.TQC-630166
    g_rec_b         LIKE type_file.num5,              #單身筆數             #No.FUN-680136 SMALLINT
    l_ac            LIKE type_file.num5               #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
DEFINE   p_row,p_col     LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE   g_before_input_done  LIKE type_file.num5     #NO.FUN-570109        #No.FUN-680136 SMALLINT
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose #No.FUN-680136 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680136
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW i100_w AT p_row,p_col WITH FORM "apm/42f/apmi100"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

        
    CALL cl_set_comp_visible("pma04",FALSE)    #CHI-B50015
    CALL cl_ui_init()
    LET g_wc = '1=1' CALL i100_b_fill(g_wc)   #No.TQC-6B0074
    CALL i100_menu()
    CLOSE WINDOW i100_w                 #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i100_menu()
 
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i100_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN 
               CALL i100_out() 
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470518
#            IF cl_chk_act_auth() THEN                #No.FUN-570148
             IF cl_chk_act_auth() AND l_ac != 0 THEN  #No.FUN-570148
               IF g_pma[l_ac].pma01 IS NOT NULL THEN
                  LET g_doc.column1 = "pma01"
                  LET g_doc.value1 =  g_pma[l_ac].pma01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pma),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i100_q()
   CALL i100_b_askkey()
END FUNCTION
 
FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,               #未取消的ARRAY CNT   #No.FUN-680136 SMALLINT 
    l_n             LIKE type_file.num5,               #檢查重複用          #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,               #單身鎖住否          #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,               #處理狀態            #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,               #可新增否            #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                #可刪除否            #No.FUN-680136 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pma01,pma11,pma02,pma03,pma09,pma08,pma12,pma13,pma10,pma04,pmaacti FROM pma_file WHERE pma01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_pma WITHOUT DEFAULTS FROM s_pma.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
           
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_pma_t.* = g_pma[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET  g_before_input_done = FALSE                                                                                     
               CALL i100_set_entry(p_cmd)                                                                                           
               CALL i100_set_no_entry(p_cmd)                                                                                        
               LET  g_before_input_done = TRUE                                                                                      
#No.FUN-570109 --end--     
               BEGIN WORK
               OPEN i100_bcl USING g_pma_t.pma01
               IF STATUS THEN
                  CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i100_bcl INTO g_pma[l_ac].* 
                  IF STATUS THEN
                     CALL cl_err(g_pma_t.pma01,STATUS,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO pma_file(pma01,pma02,pma03,pma04,
                                 pma08,pma09,pma10,pma11,
                                 pma12,pma13,
                                 pmaacti,pmauser,pmadate,pmaoriu,pmaorig)
            VALUES(g_pma[l_ac].pma01,g_pma[l_ac].pma02,
                   g_pma[l_ac].pma03,g_pma[l_ac].pma04,
                   g_pma[l_ac].pma08,g_pma[l_ac].pma09,
                   g_pma[l_ac].pma10,g_pma[l_ac].pma11,
                   g_pma[l_ac].pma12,g_pma[l_ac].pma13,
                   g_pma[l_ac].pmaacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_pma[l_ac].pma01,SQLCA.sqlcode,0)   #No.FUN-660129
                CALL cl_err3("ins","pma_file",g_pma[l_ac].pma01,"",
                              SQLCA.sqlcode,"","",1)  #No.FUN-660129
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET  g_before_input_done = FALSE                                                                                        
            CALL i100_set_entry(p_cmd)                                                                                              
            CALL i100_set_no_entry(p_cmd)                                                                                           
            LET  g_before_input_done = TRUE                                                                                         
#No.FUN-570109 --end--           
            INITIALIZE g_pma[l_ac].* TO NULL      #900423
            LET g_pma[l_ac].pma03 = 3         #Body default
            LET g_pma[l_ac].pma04 = 0         #Body default
            LET g_pma[l_ac].pma08 = 0         #Body default
            LET g_pma[l_ac].pma09 = 0         #Body default
            LET g_pma[l_ac].pma10 = 0         #Body default
            LET g_pma[l_ac].pma12 = 3         #Body default
            LET g_pma[l_ac].pma13 = 0         #Body default
            LET g_pma[l_ac].pmaacti = 'Y'         #Body default
            LET g_pma_t.* = g_pma[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pma01
 
        AFTER FIELD pma01                        #check 編號是否重複
            IF g_pma[l_ac].pma01 IS NOT NULL THEN
            IF g_pma[l_ac].pma01 != g_pma_t.pma01 OR
               (g_pma[l_ac].pma01 IS NOT NULL AND g_pma_t.pma01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM pma_file
                    WHERE pma01 = g_pma[l_ac].pma01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_pma[l_ac].pma01 = g_pma_t.pma01
                    NEXT FIELD pma01
                END IF
            END IF
            END IF
 
        AFTER FIELD pma11   
            IF NOT cl_null(g_pma[l_ac].pma11) THEN
               IF g_pma[l_ac].pma11 NOT MATCHES '[1234678C]' THEN #No.5058
                  NEXT FIELD pma11
               END IF
            END IF
 
        AFTER FIELD pma03
            IF g_pma[l_ac].pma03 IS NOT NULL THEN
               IF g_pma[l_ac].pma03 NOT MATCHES '[2356]' THEN NEXT FIELD pma03
               END IF
            END IF
   
        #No.TQC-790077  --Begin
        AFTER FIELD pma04
            IF g_pma[l_ac].pma04 IS NOT NULL THEN
               IF g_pma[l_ac].pma04 <0 OR g_pma[l_ac].pma04 > 100 THEN
                  CALL cl_err(g_pma[l_ac].pma04,'atm-070',0)
                  LET g_pma[l_ac].pma04 = g_pma_t.pma04
                  NEXT FIELD pma04
               END IF
            END IF
        #No.TQC-790077  --End  
 
        BEFORE DELETE                            #是否取消單身
            IF g_pma_t.pma01 IS NOT NULL THEN
               SELECT COUNT(*) INTO l_n FROM aah_file WHERE aah01=g_pma_t.pma01
               IF l_n>0 THEN 
                  CALL cl_err(g_pma_t.pma01,'apm-190',1)
                  EXIT INPUT
               END IF
              #-CHI-9B0043-add-
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM pmm_file WHERE pmm20 = g_pma_t.pma01
               IF g_cnt > 0 THEN 
                  LET g_msg = '#chk1 pmm_file:',g_pma_t.pma01
                  CALL cl_err(g_msg,'asm-091',1)
                  EXIT INPUT
               END IF
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM poy_file WHERE poy06 = g_pma_t.pma01
               IF g_cnt > 0 THEN 
                  LET g_msg = '#chk2 poy_file:',g_pma_t.pma01
                  CALL cl_err(g_msg,'asm-091',1)
                  EXIT INPUT
               END IF
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM apa_file WHERE apa11 = g_pma_t.pma01
               IF g_cnt > 0 THEN 
                  LET g_msg = '#chk3 apa_file:',g_pma_t.pma01
                  CALL cl_err(g_msg,'asm-091',1)
                  EXIT INPUT
               END IF
              #-CHI-9B0043-end-
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                 #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "pma01"                #No.FUN-9B0098 10/02/24
                LET g_doc.value1 =  g_pma[l_ac].pma01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                               #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM pma_file WHERE pma01 = g_pma_t.pma01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_pma_t.pma01,SQLCA.sqlcode,0)
                   CALL cl_err3("del","pma_file",g_pma_t.pma01,"",
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i100_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pma[l_ac].* = g_pma_t.*
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pma[l_ac].pma01,-263,1)
               LET g_pma[l_ac].* = g_pma_t.*
            ELSE
               UPDATE pma_file 
                             SET pma01=g_pma[l_ac].pma01,
                                 pma02=g_pma[l_ac].pma02,
                                 pma03=g_pma[l_ac].pma03,
                                 pma04=g_pma[l_ac].pma04,
                                 pma08=g_pma[l_ac].pma08,
                                 pma09=g_pma[l_ac].pma09,
                                 pma10=g_pma[l_ac].pma10,
                                 pma11=g_pma[l_ac].pma11,
                                 pma12=g_pma[l_ac].pma12,
                                 pma13=g_pma[l_ac].pma13,
                                 pmaacti=g_pma[l_ac].pmaacti,
                                 pmamodu=g_user,
                                 pmadate=g_today
                WHERE pma01 = g_pma_t.pma01
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_pma[l_ac].pma01,SQLCA.sqlcode,0)   #No.FUN-660129
                   CALL cl_err3("upd","pma_file",g_pma[l_ac].pma01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   LET g_pma[l_ac].* = g_pma_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i100_bcl
                   COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac      #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN 
                  LET g_pma[l_ac].* = g_pma_t.*
               #FUN-D30034---add---str---
               ELSE
                  CALL g_pma.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034---add---end---
               END IF 
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30034 add
            CLOSE i100_bcl
            COMMIT WORK
 
#---------No.MOD-610077 mark
#       ON ACTION special_desc
#          IF INFIELD(pma01) THEN
#             CLOSE i100_bcl
#             LET g_msg = 'apmi102 ',g_pma[l_ac].pma01 CALL cl_cmdrun(g_msg)
#          END IF
#--------No.MOD-610077 end
 
        ON ACTION CONTROLN
            CALL i100_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pma01) AND l_ac > 1 THEN
                LET g_pma[l_ac].* = g_pma[l_ac-1].*
                NEXT FIELD pma01
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
 
    CLOSE i100_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i100_b_askkey()
    CLEAR FORM
    CALL g_pma.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON pma01,pma11,pma02,pma03,pma09,pma08,pma12,pma13,
                      pma10,pma04,pmaacti
            FROM s_pma[1].pma01,s_pma[1].pma11,s_pma[1].pma02,s_pma[1].pma03,
                 s_pma[1].pma09,s_pma[1].pma08,s_pma[1].pma12,s_pma[1].pma13,
                 s_pma[1].pma10,s_pma[1].pma04,
                 s_pma[1].pmaacti
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmauser', 'pmagrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i100_b_fill(g_wc)
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200) 
 
    LET g_sql =
        "SELECT pma01,pma11,pma02,pma03,pma09,pma08,pma12,pma13,",
        "       pma10,pma04,pmaacti ", #FUN-4C0095 
        " FROM pma_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY pma01"
    PREPARE i100_pb FROM g_sql
    DECLARE pma_curs CURSOR FOR i100_pb
 
    CALL g_pma.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pma_curs INTO g_pma[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pma.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    DISPLAY g_cnt   TO FORMONLY.cn3  
END FUNCTION
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pma TO s_pma.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
    ON ACTION related_document  #No.MOD-470518
      LET g_action_choice="related_document"
      EXIT DISPLAY
   ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
     
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i100_out()
   DEFINE
       l_i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
       l_name          LIKE type_file.chr20,         # External(Disk) file name   #No.FUN-680136 VARCHAR(20)
       l_pma           RECORD                        # FUN-4C0095
           pma01       LIKE pma_file.pma01,   
           pma11       LIKE pma_file.pma11,   
           pma02       LIKE pma_file.pma02,   
           pma03       LIKE pma_file.pma03,   
           pma09       LIKE pma_file.pma09,   
           pma08       LIKE pma_file.pma08,   
           pma12       LIKE pma_file.pma12,   
           pma13       LIKE pma_file.pma13,   
           pma10       LIKE pma_file.pma10,   
           pma04       LIKE pma_file.pma04,   
           pmaacti     LIKE type_file.chr1    #No.FUN-680136
                       END RECORD,
       l_za05          LIKE type_file.chr1000,               #        #No.FUN-680136 VARCHAR(40)
       l_chr           LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-820002
#No.TQC-710076 -- begin --
#    IF cl_null(g_wc)  THEN LET g_wc = " 1=1 " END IF
  IF cl_null(g_wc) THEN
     CALL cl_err("","9057",0)
     RETURN
  END IF
 
#No.FUN-820002--start--
  #報表轉為使用 p_query                                                                                                             
  LET l_cmd = 'p_query "apmi100" "',g_wc CLIPPED,'"'                                                                                
  CALL cl_cmdrun(l_cmd)                                                                                                             
  RETURN
 
##No.TQC-710076 -- end --
#   CALL cl_wait()
#   CALL cl_outnam('apmi100') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql =
#       "SELECT pma01,pma11,pma02,pma03,pma09,pma08,pma12,pma13,",
#       "       pma10,pma04,pmaacti ",
#       " FROM pma_file",
#       " WHERE ", g_wc CLIPPED,                     #單身
#       " ORDER BY pma01 "
#   PREPARE i100_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i100_co                         # CURSOR
#       CURSOR FOR i100_p1
 
#   START REPORT i100_rep TO l_name
 
#   FOREACH i100_co INTO l_pma.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i100_rep(l_pma.*)
#   END FOREACH
 
#   FINISH REPORT i100_rep
 
#   CLOSE i100_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i100_rep(sr)
#   DEFINE
#       l_print31       LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
#       l_print34       LIKE type_file.chr20,    #No.FUN-680136 VARCHAR(20)
#       l_print37       LIKE type_file.chr20,    #No.FUN-680136 VARCHAR(20)
#       l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
#       sr              RECORD                   # FUN-4C0095
#           pma01       LIKE pma_file.pma01,   
#           pma11       LIKE pma_file.pma11,   
#           pma02       LIKE pma_file.pma02,   
#           pma03       LIKE pma_file.pma03,   
#           pma09       LIKE pma_file.pma09,   
#           pma08       LIKE pma_file.pma08,   
#           pma12       LIKE pma_file.pma12,   
#           pma13       LIKE pma_file.pma13,   
#           pma10       LIKE pma_file.pma10,   
#           pma04       LIKE pma_file.pma04,   
#           pmaacti     LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
#                       END RECORD,
#       l_chr           LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.pma01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno" 
#           PRINT g_head CLIPPED,pageno_total     
# #         PRINT                            #TQC-6A0090
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#           PRINT g_dash1 
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           IF sr.pmaacti = 'N' THEN 
#               LET l_print31 = '*'
#           ELSE
#               LET l_print31 = NULL
#           END IF
#           LET l_print34 = NULL 
#           CASE sr.pma03
#                WHEN '1' LET l_print34 = sr.pma03,':',g_x[13] CLIPPED
#                WHEN '2' LET l_print34 = sr.pma03,':',g_x[14] CLIPPED
#                WHEN '3' LET l_print34 = sr.pma03,':',g_x[15] CLIPPED
#                WHEN '4' LET l_print34 = sr.pma03,':',g_x[16] CLIPPED
#                WHEN '5' LET l_print34 = sr.pma03,':',g_x[17] CLIPPED
#                WHEN '6' LET l_print34 = sr.pma03,':',g_x[18] CLIPPED
#                OTHERWISE EXIT CASE
#           END CASE
#           LET l_print37 = NULL 
#           CASE sr.pma12
#                WHEN '1' LET l_print37 = sr.pma12,':',g_x[21] CLIPPED
#                WHEN '2' LET l_print37 = sr.pma12,':',g_x[22] CLIPPED
#                WHEN '3' LET l_print37 = sr.pma12,':',g_x[23] CLIPPED
#                WHEN '4' LET l_print37 = sr.pma12,':',g_x[24] CLIPPED
#                WHEN '5' LET l_print37 = sr.pma12,':',g_x[25] CLIPPED
#                WHEN '6' LET l_print37 = sr.pma12,':',g_x[26] CLIPPED
#                WHEN '7' LET l_print37 = sr.pma12,':',g_x[27] CLIPPED
#                WHEN '8' LET l_print37 = sr.pma12,':',g_x[28] CLIPPED
#                OTHERWISE EXIT CASE
#           END CASE
 
#           PRINT COLUMN g_c[31],l_print31,
#                 COLUMN g_c[32],sr.pma01,
#                 COLUMN g_c[33],sr.pma02,
#                 COLUMN g_c[34],l_print34,
#                 COLUMN g_c[35],sr.pma08 USING '#####&',
#                 COLUMN g_c[36],sr.pma09 USING '#####&',
#                 COLUMN g_c[37],l_print37,
#                 COLUMN g_c[38],sr.pma04 USING '####&.&&',
#                 COLUMN g_c[39],sr.pma10 USING '#####&',
#                 COLUMN g_c[40],sr.pma13 USING '#####&'
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash
##NO.TQC-630166 start--
##                    IF g_wc[001,080] > ' ' THEN
##		       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
##                    IF g_wc[071,140] > ' ' THEN
##		       PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
##                    IF g_wc[141,210] > ' ' THEN
##		       PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                    CALL cl_prt_pos_wc(g_wc)
##NO.TQC-630166 end--
#           END IF
#           PRINT g_dash
#           LET l_trailer_sw = 'n'
#           #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED #TQC-5B0037 mark
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #TQC-5B0037 add
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED #TQC-5B0037 mark
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-5B0037 add
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end
#No.FUN-570109 --start--                                                                                                            
FUNCTION i100_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("pma01",TRUE)                                                                                           
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i100_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1                           #No.FUN-680136 VARCHAR(1)
 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                               
     CALL cl_set_comp_entry("pma01",FALSE)                                                                                          
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--                    
