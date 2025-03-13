# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp013.4gl
# Descriptions...: 工單重工結案設定作業
# Date & Author..: 96/02/15  By  Felicity Tseng
# Modify.........: 96/12/06  By Star add field sfbuser,sfbgrup...
# Modify.........: No:7773 03/08/13 Melody 避免與 asfq301 查詢結果不符, 本月入庫數/月底累計數 改為 LIKE sfb_file.sfb08, 原為 INTEGER
# Modify.........: No:7778 03/08/13 Melody SQL加上 AND tlf13='asft6201' 否則重工工單之發退料數量都會算進去
# Modify.........: MOD-480417 04/09/03 by echo 已作廢之工單仍會出現在成本結案程式中.
# Modify.........: No.FUN-4C0099 05/01/07 By kim 報表轉XML功能
# Modify.........: NO.MOD-590014 05/09/05 By Rosayu 單身刪除後資料沒有被刪除
# Modify.........: NO.FUN-5A0054 05/10/12 By Sarah 維護單身之成會結案日(sfb38)時, 須檢核該結案日期不可小於目前最後之入/出庫異動日(tlf06)
# Modify.........: NO.FUN-5B0030 05/11/23 By Sarah 控管成本結案日(sfb38)不可小於成會關帳日(g_sma.sma53)
# Modify.........: NO.MOD-650028 06/05/08 By Claire 單身刪除,新增功能取消及單身筆數限制取消 
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
 
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.MOD-720099 07/03/02 By pengu 單身修改時會將累計入庫量update =0 
# Modify.........: No.FUN-7B0018 08/02/25 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-950240 09/05/22 By wujie 成會結案日清空后，sfb36,sfb37和sfb28都要清空
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.MOD-BC0273 11/12/28 By ck2yuan 工單成會結案後，清空成會日期
# Modify.........: No.CHI-C20055 12/05/11 By bart 工單結案請將委外採購單一併結案
# Modify.........: No:FUN-C80092 12/09/11 By xujing 成本相關作業程式日誌

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     m_sfb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sfb01       LIKE sfb_file.sfb01,
        sfb81       LIKE sfb_file.sfb81,
        sfb02       LIKE sfb_file.sfb02,
        sfb04       LIKE sfb_file.sfb04,
        sfb05       LIKE sfb_file.sfb05,
        ima02       LIKE ima_file.ima02,
        sfb08       LIKE sfb_file.sfb08, #No:7773 
        qty1        LIKE sfb_file.sfb08, #No:7773 
        qty2        LIKE sfb_file.sfb08, #No:7773 
        sfb99       LIKE sfb_file.sfb99,
        sfb38       LIKE sfb_file.sfb38
                    END RECORD,
    m_sfb_t         RECORD                 #程式變數 (舊值)
        sfb01       LIKE sfb_file.sfb01,
        sfb81       LIKE sfb_file.sfb81,
        sfb02       LIKE sfb_file.sfb02,
        sfb04       LIKE sfb_file.sfb04,
        sfb05       LIKE sfb_file.sfb05,
        ima02       LIKE ima_file.ima02,
        sfb08       LIKE sfb_file.sfb08, #No:7773 
        qty1        LIKE sfb_file.sfb08, #No:7773
        qty2        LIKE sfb_file.sfb08, #No:7773
        sfb99       LIKE sfb_file.sfb99,
        sfb38       LIKE sfb_file.sfb38
                    END RECORD,
    g_sfbacti       LIKE  sfb_file.sfbacti,     
    g_sfbuser       LIKE  sfb_file.sfbuser,     
    g_sfbgrup       LIKE  sfb_file.sfbgrup,     
    g_sfbmodu       LIKE  sfb_file.sfbmodu,     
    g_sfbdate       LIKE  sfb_file.sfbdate,     
    g_wc2,g_sql     STRING,#TQC-630166
    b_date,e_date   LIKE type_file.dat,           #No.FUN-680122 DATE
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_sl            LIKE type_file.num5           #No.FUN-680122 SMALLINT              #目前處理的SCREEN LINE
 
 
 
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680122 INTEGER
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cka00         LIKE cka_file.cka00     #FUN-C80092 add
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0146
 
   OPEN WINDOW p013_w WITH FORM "axc/42f/axcp013"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02) RETURNING g_chr,b_date,e_date
   DISPLAY BY NAME g_ccz.ccz01,g_ccz.ccz02,e_date
 
   CALL p013_menu()
 
   CLOSE WINDOW p013_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p013_menu()
   WHILE TRUE
      CALL p013_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL p013_q() 
            END IF
         WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL p013_b() 
           ELSE
              LET g_action_choice = NULL
           END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN
               CALL p013_out() 
            END IF
         WHEN "help"  CALL cl_show_help()
         WHEN "exit" EXIT WHILE
         WHEN "controlg" CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p013_q()
   CALL p013_b_askkey()
END FUNCTION
 
FUNCTION p013_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680122 SMALLINT
       l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680122 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680122 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680122 VARCHAR(1)
       l_sfb28         LIKE sfb_file.sfb28,
       l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680122 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680122 SMALLINT
DEFINE l_tlf06         LIKE tlf_file.tlf06    #FUN-5A0054
#---------No.MOD-720099 add
DEFINE l_tlf02          LIKE tlf_file.tlf02
DEFINE l_tlf10          LIKE tlf_file.tlf10
#---------No.MOD-720099 end
DEFINE l_cnt           LIKE type_file.num5    #CHI-C20055
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
    "SELECT sfb01,sfb81,sfb02,sfb04,sfb05,'',sfb08,0,0,sfb99,sfb38 ",
    " FROM sfb_file ",
    " WHERE sfb01 = ? ",
    " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p013_bcl CURSOR FROM g_forupd_sql
 
       #MOD-650028-begin
       #LET l_allow_insert = cl_detail_input_auth("insert")
       #LET l_allow_delete = cl_detail_input_auth("delete") 
        LET l_allow_insert = FALSE
        LET l_allow_delete = FALSE
       #MOD-650028-end
 
        INPUT ARRAY m_sfb WITHOUT DEFAULTS FROM s_sfb.* 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            LET l_lock_sw = 'N'
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET m_sfb_t.*=m_sfb[l_ac].*
               CALL s_log_ins(g_prog,g_ccz.ccz01,g_ccz.ccz02,g_wc2,'') RETURNING g_cka00   #FUN-C80092 add
               BEGIN WORK
             
               OPEN p013_bcl USING m_sfb_t.sfb01
               IF SQLCA.sqlcode THEN
                   CALL cl_err(m_sfb_t.sfb01,SQLCA.sqlcode,1)
                   LET l_lock_sw='Y' 
               ELSE
                   FETCH p013_bcl INTO m_sfb[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(m_sfb_t.sfb01,SQLCA.sqlcode,1)
                      LET l_lock_sw='Y' 
                   END IF
                  #-----------------No.MOD-720099 add--------------------
                   DECLARE p013_c3 CURSOR FOR
                     SELECT tlf02,tlf06,tlf10 FROM tlf_file    
                           WHERE (tlf62=m_sfb[l_ac].sfb01  or 
                                  tlf026=m_sfb[l_ac].sfb01  or 
                                  tlf036=m_sfb[l_ac].sfb01 )
                             AND tlf06 <= e_date
                             AND ((tlf02=25 AND tlf03=50) OR  
                                  (tlf02=50 AND tlf03=25) OR 
                                  (tlf02=60 AND tlf03=50) OR 
                                  (tlf02=50 AND tlf03=60) )  
                             AND tlf01 = m_sfb[l_ac].sfb05
                             AND tlf13='asft6201' 
                   FOREACH p013_c3 INTO l_tlf02,l_tlf06,l_tlf10
                      IF SQLCA.sqlcode THEN 
                         CALL cl_err('p013_c2',SQLCA.sqlcode,0)
                         EXIT FOREACH 
                      END IF
                      IF l_tlf02=50 THEN LET l_tlf10=l_tlf10*-1 END IF
                      LET m_sfb[l_ac].qty2=m_sfb[l_ac].qty2+l_tlf10
                      IF l_tlf06>=b_date THEN
                         LET m_sfb[l_ac].qty1=m_sfb[l_ac].qty1+l_tlf10
                      END IF
                   END FOREACH
                  #-------------------No.MOD-720099 end-----------------------
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
{
            SELECT sfbacti,sfbuser,sfbgrup,sfbdate,sfbmodu 
              INTO g_sfbacti,g_sfbuser,g_sfbgrup,g_sfbdate,g_sfbmodu 
              FROM sfb_file WHERE sfb01 = m_sfb[l_ac].sfb01 
            IF cl_null(g_sfbuser) THEN LET g_sfbuser = g_user END IF 
            #使用者所屬群
            IF cl_null(g_sfbgrup) THEN LET g_sfbgrup = g_grup END IF
            IF cl_null(g_sfbdate) THEN LET g_sfbdate = g_today END IF 
            DISPLAY  g_sfbuser,g_sfbgrup,g_sfbdate,g_sfbmodu 
                 TO    sfbuser,  sfbgrup,  sfbdate ,  sfbmodu 
            NEXT FIELD sfb99
        AFTER FIELD sfb38 
            IF (m_sfb_t.sfb99 != m_sfb[l_ac].sfb99 ) 
            OR (m_sfb_t.sfb38 != m_sfb[l_ac].sfb38 )  THEN 
                LET g_sfbmodu = g_user                     #修改者
                LET g_sfbdate = g_today                  #修改日期
                DISPLAY  g_sfbmodu,g_sfbdate
                     TO    sfbmodu,  sfbdate
            END IF 
}
  #     BEFORE FIELD sfb38
  #         IF l_lock_sw = 'Y' THEN LET l_modify_flag='N' END IF
  #         IF l_modify_flag='N' THEN
  #            LET m_sfb[l_ac].sfb99 = m_sfb_t.sfb99
  #            DISPLAY m_sfb[l_ac].sfb38 TO s_sfb[l_sl].sfb38
  #            NEXT FIELD sfb99
  #         END IF
 
        #start FUN-5A0054
         AFTER FIELD sfb38
            #最後之入/出庫異動日
            SELECT max(tlf06) INTO l_tlf06 FROM tlf_file
             WHERE tlf62=m_sfb[l_ac].sfb01 and (tlf02=50 OR tlf03=50)
            #開單日期
            IF cl_null(l_tlf06) THEN LET l_tlf06=m_sfb[l_ac].sfb81 END IF
            #預計起始生產日期
            IF cl_null(l_tlf06) THEN
               SELECT sfb13 INTO l_tlf06 FROM sfb_file
                WHERE sfb01=m_sfb[l_ac].sfb01
            END IF
            #成會結案日不可小於目前最後之入/出庫異動日(l_tlf06)
            IF m_sfb[l_ac].sfb38 < l_tlf06 THEN
               CALL cl_err('','axc-205',0) NEXT FIELD sfb38
            END IF
        #end FUN-5A0054
#No.MOD-950240 --begin
            IF NOT cl_null(m_sfb_t.sfb38) AND cl_null(m_sfb[l_ac].sfb38) THEN
               IF YEAR(m_sfb_t.sfb38)*12+MONTH(m_sfb_t.sfb38) <g_ccz.ccz01*12+g_ccz.ccz02 THEN
                  LET m_sfb[l_ac].sfb38 =m_sfb_t.sfb38
                  CALL cl_err('','axc-194',0)
                  NEXT FIELD sfb38
               END IF
            END IF
#No.MOD-950240 --end
 
#No.B196&B330 mark by Ostrich 010430
 
 
   #     AFTER ROW
   #        UPDATE sfb_file SET sfb99=m_sfb[l_ac].sfb99,
   #                            sfb38=m_sfb[l_ac].sfb38
   #               WHERE sfb01=m_sfb[l_ac].sfb01
   #        IF SQLCA.sqlcode THEN
   #           CALL cl_err(m_sfb[l_ac].sfb01,SQLCA.sqlcode,1)
   #        END IF
#重新select工單結案狀態,然後正確更新工單結案碼 sfb28 = '1' or '3'
        #MOD-590014 add
        BEFORE DELETE
            IF NOT cl_null(m_sfb_t.sfb01) THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw ="Y" THEN
                  CALL cl_err("",-263,1)
                  CANCEL DELETE
               END IF
               DELETE FROM sfb_file where sfb01 = m_sfb_t.sfb01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(m_sfb_t.sfb01,SQLCA.sqlcode,0)   #No.FUN-660127
                  CALL cl_err3("del","sfb_file",m_sfb_t.sfb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660127
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               #NO.FUN-7B0018 08/02/25 add --begin
               IF NOT s_industry('std') THEN
                  IF NOT s_del_sfbi(m_sfb_t.sfb01,'') THEN
                     ROLLBACK WORK   
                     CANCEL DELETE
                  END IF
               END IF
               #NO.FUN-7B0018 08/02/25 add --end
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete OK"
               CLOSE p013_bcl
               COMMIT WORK
            END IF
        #MOD-590014 end
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET m_sfb[l_ac].* = m_sfb_t.*
               CLOSE p013_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(m_sfb[l_ac].sfb01,-263,1)
                LET m_sfb[l_ac].* = m_sfb_t.*
            ELSE
               #start FUN-5B0030
                IF (NOT cl_null(m_sfb_t.sfb38) AND
                    m_sfb[l_ac].sfb38 != m_sfb_t.sfb38) OR
                   cl_null(m_sfb_t.sfb38) THEN
                   #FUN-B50090 add begin-------------------------
                   #重新抓取關帳日期
                   SELECT sma53 INTO g_sma.sma53 FROM sma_file WHERE sma00='0'
                   #FUN-B50090 add -end--------------------------
                   #成會結案日不可小於成會關帳日
                   IF m_sfb[l_ac].sfb38 < g_sma.sma53 THEN
                      CALL cl_err('','axm-164',0)
                      LET m_sfb[l_ac].sfb38 = m_sfb_t.sfb38
                      DISPLAY BY NAME m_sfb[l_ac].sfb38
                      NEXT FIELD sfb38
                   END IF
                END IF
               #end FUN-5B0030
                IF cl_null(m_sfb[l_ac].sfb38)  THEN
                    SELECT sfb28 INTO l_sfb28 
                      FROM sfb_file 
                     WHERE sfb01 = m_sfb[l_ac].sfb01
                    IF NOT STATUS AND l_sfb28 = '3' THEN
#No.MOD-950240 --begin
                       IF g_sma.sma72 ='N' THEN
                          UPDATE sfb_file 
                             SET sfb99=m_sfb[l_ac].sfb99,
                                 sfb36=NULL,
                                 sfb37=NULL,
                                 sfb38=NULL,
                                 sfb28 = NULL
                           WHERE sfb01=m_sfb[l_ac].sfb01
                       ELSE
                          UPDATE sfb_file 
                             SET sfb99=m_sfb[l_ac].sfb99,
                                 sfb38=m_sfb[l_ac].sfb38,
                                 sfb28 = '1',
                                 sfb37 = NULL                #MOD-BC0273 add
                           WHERE sfb01=m_sfb[l_ac].sfb01
                       END IF
#No.MOD-950240 --end
                        IF SQLCA.sqlcode THEN
#                           CALL cl_err(m_sfb[l_ac].sfb01,SQLCA.sqlcode,1)   #No.FUN-660127
                            CALL cl_err3("upd","sfb_file",m_sfb[l_ac].sfb01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660127
                            CALL s_log_upd(g_cka00,'N')    #FUN-C80092 add
                        ELSE
                            COMMIT WORK
                            CALL s_log_upd(g_cka00,'Y')    #FUN-C80092 add
                        END IF
                    END IF
                ELSE
                    UPDATE sfb_file 
                       SET sfb99=m_sfb[l_ac].sfb99,
                           sfb38=m_sfb[l_ac].sfb38,
                           sfb28='3',
                           sfb04='8'    #No.+369 010705 add by ann
                     WHERE sfb01=m_sfb[l_ac].sfb01
                    IF SQLCA.sqlcode THEN
#                       CALL cl_err(m_sfb[l_ac].sfb01,SQLCA.sqlcode,1)   #No.FUN-660127
                        CALL cl_err3("upd","sfb_file",m_sfb[l_ac].sfb01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660127
                        CALL s_log_upd(g_cka00,'N')    #FUN-C80092 add
                    ELSE
                    #CHI-C20055---begin
                        SELECT COUNT(*) INTO l_cnt FROM pmm_file WHERE pmm01 = m_sfb[l_ac].sfb01
                        IF cl_null(l_cnt) OR l_cnt = 0 THEN
                           COMMIT WORK
                           CALL s_log_upd(g_cka00,'Y')    #FUN-C80092 add
                        ELSE 
                           UPDATE pmm_file
                              SET pmm25 = '6'
                              WHERE pmm01 = m_sfb[l_ac].sfb01
                              IF SQLCA.sqlcode THEN
                                 CALL cl_err3("upd","pmm_file",m_sfb[l_ac].sfb01,"",SQLCA.sqlcode,"","",1)
                              ELSE
                                 COMMIT WORK
                                 CALL s_log_upd(g_cka00,'Y')    #FUN-C80092 add
                              END IF 
                        END IF 
                        UPDATE pmn_file
                           SET pmn16 = '6'
                         WHERE pmn41 = m_sfb[l_ac].sfb01
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","pmn_file",m_sfb[l_ac].sfb01,"",SQLCA.sqlcode,"","",1)
                           CALL s_log_upd(g_cka00,'N')    #FUN-C80092 add
                        ELSE
                           COMMIT WORK
                           CALL s_log_upd(g_cka00,'Y')    #FUN-C80092 add
                        END IF 
                       #COMMIT WORK
                    #CHI-C20055---end
                    END IF
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET m_sfb[l_ac].* = m_sfb_t.*
               END IF
               CLOSE p013_bcl
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')    #FUN-C80092 add
               EXIT INPUT
            END IF
            CLOSE p013_bcl
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')    #FUN-C80092 add
 
  #     ON ACTION CONTROLN
  #         CALL p013_b_askkey()
  #         EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        END INPUT
 
END FUNCTION
 
FUNCTION p013_b_askkey()
    CLEAR FORM
    CALL m_sfb.clear()
    DISPLAY BY NAME g_ccz.ccz01,g_ccz.ccz02,e_date
    CONSTRUCT g_wc2 ON sfb01,sfb81, sfb05, sfb02, sfb04, sfb08, sfb99, sfb38
            FROM s_sfb[1].sfb01,s_sfb[1].sfb81,s_sfb[1].sfb05,s_sfb[1].sfb02,
                 s_sfb[1].sfb04,s_sfb[1].sfb08,s_sfb[1].sfb99,s_sfb[1].sfb38
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
  
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
 
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL p013_b_fill(g_wc2)
END FUNCTION
 
FUNCTION p013_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_tlf02          LIKE tlf_file.tlf02           #No.FUN-680122 SMALLINT
DEFINE l_tlf06          LIKE tlf_file.tlf06           #No.FUN-680122 DATE
DEFINE l_tlf10          LIKE tlf_file.tlf10           #No.FUN-680122 DEC(15,3)
DEFINE p_wc2            LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(200)
 
 ##### MOD-480417 #####
{
    LET g_sql =
        "SELECT sfb01,sfb81,sfb02,sfb04,sfb05,ima02,sfb08,0,0,sfb99,sfb38 ",
        " FROM sfb_file LEFT OUTER JOIN ima_file ON sfb05= ima01 ",
        " WHERE sfb05= ima_file.ima01 AND sfb02 != '13' AND ", p_wc2 CLIPPED,
        " ORDER BY 1"
}
    LET g_sql =
        "SELECT sfb01,sfb81,sfb02,sfb04,sfb05,ima02,sfb08,0,0,sfb99,sfb38 ",
        " FROM sfb_file LEFT OUTER JOIN ima_file ON sfb05= ima01 ",
        " WHERE sfb02 != '13' AND sfb87 !='X' AND ", p_wc2 CLIPPED,   
        " ORDER BY 1"
 ##### MOD-480417 #####
 
    PREPARE p013_pb FROM g_sql
    DECLARE sfb_curs CURSOR FOR p013_pb
 
    CALL m_sfb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH sfb_curs INTO m_sfb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        MESSAGE m_sfb[g_cnt].sfb01
        CALL ui.Interface.refresh()
        DECLARE p013_c2 CURSOR FOR
          SELECT tlf02,tlf06,tlf10 FROM tlf_file        # 當月成品入庫量
                WHERE (tlf62=m_sfb[g_cnt].sfb01  or 
                       tlf026=m_sfb[g_cnt].sfb01  or 
                       tlf036=m_sfb[g_cnt].sfb01 )
                  AND tlf06 <= e_date
                  AND ((tlf02=25 AND tlf03=50) OR  
                       (tlf02=50 AND tlf03=25) OR 
                       (tlf02=60 AND tlf03=50) OR 
                       (tlf02=50 AND tlf03=60) )  
                  AND tlf01 = m_sfb[g_cnt].sfb05
                  AND tlf13='asft6201' #No:7778
        FOREACH p013_c2 INTO l_tlf02,l_tlf06,l_tlf10
           IF SQLCA.sqlcode THEN 
             CALL cl_err('p013_c2',SQLCA.sqlcode,0)   
              EXIT FOREACH 
           END IF
           IF l_tlf02=50 THEN LET l_tlf10=l_tlf10*-1 END IF
           LET m_sfb[g_cnt].qty2=m_sfb[g_cnt].qty2+l_tlf10
           IF l_tlf06>=b_date THEN
              LET m_sfb[g_cnt].qty1=m_sfb[g_cnt].qty1+l_tlf10
           END IF
        END FOREACH
        LET g_cnt = g_cnt + 1
       #MOD-650028-begin
        #IF g_cnt > g_max_rec THEN
        #   CALL cl_err( '', 9035, 0 )
        #   EXIT FOREACH
        #END IF
       #MOD-650028-end
    END FOREACH
    CALL m_sfb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p013_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY m_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
   ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION p013_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),                # External(Disk) file name
        l_sfb   RECORD LIKE sfb_file.*,
        l_za05          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40),         #
        l_chr           LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
 
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
    CALL cl_outnam('axcp013') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM sfb_file ",          # 組合出 SQL 指令
              " WHERE sfb02 != '13' AND ",g_wc2 CLIPPED
    PREPARE p013_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p013_co CURSOR FOR p013_p1
 
    START REPORT p013_rep TO l_name
 
    FOREACH p013_co INTO l_sfb.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT p013_rep(l_sfb.*)
    END FOREACH
 
    FINISH REPORT p013_rep
 
    CLOSE p013_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p013_rep(sr)
    DEFINE l_ima02   LIKE ima_file.ima02
    DEFINE l_ima021   LIKE ima_file.ima021
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1),
        sr RECORD LIKE sfb_file.*,
        l_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.sfb01
 
    FORMAT
        PAGE HEADER
          PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
          LET g_pageno=g_pageno+1
          LET pageno_total=PAGENO USING '<<<','/pageno'
          PRINT g_head CLIPPED,pageno_total
          PRINT 
          PRINT g_dash
          PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                g_x[36],g_x[37],g_x[38]
          PRINT g_dash1
          LET l_trailer_sw = 'y'
        ON EVERY ROW
            SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
               WHERE ima01=sr.sfb05
            IF SQLCA.sqlcode THEN 
               LET l_ima02 = NULL 
               LET l_ima021 = NULL 
            END IF
 
            IF sr.sfb08   = 'N' THEN PRINT '*'; ELSE PRINT ' '; END IF
            PRINT sr.sfb01,
                  COLUMN g_c[32],sr.sfb04,
                  COLUMN g_c[33],sr.sfb05,
                  COLUMN g_c[34],l_ima02,
                  COLUMN g_c[35],l_ima021,
                  COLUMN g_c[36],cl_numfor(sr.sfb08,36,0), #  sr.sfb08 USING "#######&",  #  
                  COLUMN g_c[37],cl_numfor(sr.sfb09,37,0), #  sr.sfb09 USING "#######&",  #  
                  COLUMN g_c[38],sr.sfb38
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc2,'sfb01,sfb25')
                    RETURNING g_sql
               PRINT g_dash
            #TQC-630166
            {
               IF g_sql[001,080] > ' ' THEN
                       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
               IF g_sql[071,140] > ' ' THEN
                       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
               IF g_sql[141,210] > ' ' THEN
                       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
            }
              CALL cl_prt_pos_wc(g_sql)
            #END TQC-630166
            END IF
            PRINT g_dash
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[7] CLIPPED
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
