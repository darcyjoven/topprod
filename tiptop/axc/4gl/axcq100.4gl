# Prog. Version..: '5.30.09-13.09.06(00000)'     #
#
# Pattern name...: axcq100.4gl
# Descriptions...: 
# Date & Author..: 12/09/03 By fengrui NO.FUN-C80092
# Modify.........: No.FUN-D10107 13/01/22 By fengrui 添加資料根據語言別轉換簡繁體功能
# Modify.........: No:MOD-D60055 13/06/06 By wujie 原作者汇出excel写错数组
# Modify.........: No:MOD-D90047 13/09/10 By suncx 在制期末應該跟在制期初一樣從cch抓取資料
# Modify.........: No:FUN-D90055 13/09/17 By fengrui 差異分析人工制費調整
# Modify.........: No:MOD-DB0013 13/11/04 By suncx 数值類型組SQL去掉單引號
# Modify.........: No:MOD-DB0096 13/11/14 By suncx 餘額科目表计算错误

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE 
   g_cki DYNAMIC ARRAY OF RECORD 
         cki01   LIKE cki_file.cki01,
         cki02   LIKE cki_file.cki02,
         qty1    LIKE tlf_file.tlf10,     #數量-總表
         tot1    LIKE ccc_file.ccc23,     #金額-總表
         qty2    LIKE tlf_file.tlf10,     #數量-明細表
         tot2    LIKE ccc_file.ccc23,     #金額-明細表
         qty3    LIKE tlf_file.tlf10,     #數量-差異
         tot3    LIKE ccc_file.ccc23,     #金額-差異
         cki03   LIKE cki_file.cki03
         END RECORD,

   g_cki_attr DYNAMIC ARRAY OF RECORD
         cki01   STRING ,
         cki02   STRING ,
         qty1    STRING ,     #數量-總表
         tot1    STRING ,     #金額-總表
         qty2    STRING ,     #數量-明細表
         tot2    STRING ,     #金額-明細表
         qty3    STRING ,     #數量-差異
         tot3    STRING ,     #金額-差異
         cki03   STRING 
         END RECORD, 
   g_aeh DYNAMIC ARRAY OF RECORD 
         aeh04   LIKE aeh_file.aeh04,
         tot4    LIKE ccc_file.ccc23,     #金額-科目餘額
         tot5    LIKE ccc_file.ccc23,     #金額-子系統報表
         tot6    LIKE ccc_file.ccc23      #金額-差異
         END RECORD, 
   g_aeh_attr DYNAMIC ARRAY OF RECORD 
         aeh04   STRING,
         tot4    STRING,     #金額-科目餘額
         tot5    STRING,     #金額-子系統報表
         tot6    STRING      #金額-差異
         END RECORD, 
   g_ccc DYNAMIC ARRAY OF RECORD 
         sfb01   LIKE sfb_file.sfb01,
         ccc01   LIKE ccc_file.ccc01,
         ima02   LIKE ima_file.ima02,
         ima021  LIKE ima_file.ima021,
         ccc08   LIKE ccc_file.ccc08,
         qty1    LIKE tlf_file.tlf10,     #數量-1
         qty2    LIKE tlf_file.tlf10,     #數量-2
         qty3    LIKE tlf_file.tlf10,     #數量-差異
         tot1    LIKE ccc_file.ccc23,     #金額-1
         tot2    LIKE ccc_file.ccc23,     #金額-2
         tot3    LIKE ccc_file.ccc23      #金額-差異
         END RECORD ,
   tm        RECORD
         yy     LIKE type_file.num5,
         mm     LIKE type_file.num5,
         type   LIKE type_file.chr1
         END RECORD, 
   sr        RECORD 
         sumqty1 LIKE tlf_file.tlf10,     #數量-1
         sumqty2 LIKE tlf_file.tlf10,     #數量-2
         sumqty3 LIKE tlf_file.tlf10,     #數量-差異
         sumtot1 LIKE ccc_file.ccc23,     #金額-1
         sumtot2 LIKE ccc_file.ccc23,     #金額-2
         sumtot3 LIKE ccc_file.ccc23      #金額-差異
         END RECORD ,
   g_rec_b       LIKE type_file.num5,    
   g_rec_b1      LIKE type_file.num5,     
   l_ac,l_ac1    LIKE type_file.num5,  
   l_ac2         LIKE type_file.num5,  
   l_detail      LIKE type_file.chr1  #用於記錄光標在第幾個單身
DEFINE   g_cnt,g_cnt1,g_cnt2 LIKE type_file.num10                       
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   g_replace_0     STRING  #FUN-D10107 add
DEFINE   g_replace_1     STRING  #FUN-D10107 add
 
MAIN
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("axc")) THEN
      EXIT PROGRAM
   END IF

   LET g_replace_0 = cl_getmsg('axc-920',0)  #FUN-D10107 add
   LET g_replace_1 = cl_getmsg('axc-920',2)  #FUN-D10107 add
   CALL cl_used(g_prog,g_time,1) RETURNING g_time     
   OPEN WINDOW q100_w WITH FORM "axc/42f/axcq100"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_set_comp_visible('cki01',FALSE)
   CALL q100_q()
   CALL q100_menu()
   CLOSE WINDOW q100_w                
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      
END MAIN
 
FUNCTION q100_curs()
   CLEAR FORM                            
   CALL g_cki.clear()
   CALL cl_set_head_visible("","YES")     

   LET tm.yy = g_ccz.ccz01
   LET tm.mm = g_ccz.ccz02
   LET tm.type = g_ccz.ccz28      
   INPUT BY NAME tm.yy,tm.mm,tm.type
      WITHOUT DEFAULTS 

      AFTER FIELD yy
         IF NOT cl_null(tm.yy) AND (tm.yy<1000 OR tm.yy>9999) THEN 
            CALL cl_err(tm.yy,'afa-370',0)
            NEXT FIELD yy
         END IF 

      AFTER FIELD mm
         IF NOT cl_null(tm.mm) AND tm.mm<1 OR tm.mm>12 THEN 
            CALL cl_err(tm.mm,'agl-020',0)
            NEXT FIELD mm
         END IF 
         
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
           
      ON ACTION CONTROLG 
         CALL cl_cmdask()    
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
           
      ON ACTION about         
         CALL cl_about()     
            
      ON ACTION help         
         CALL cl_show_help() 
            
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT INPUT
          
      ON ACTION qbe_save
         CALL cl_qbe_save()
            
   END INPUT
   IF INT_FLAG THEN RETURN END IF
END FUNCTION
 
FUNCTION q100_menu()
   WHILE TRUE
      CALL q100_bp("G")
      CASE g_action_choice
         WHEN "fresh"
            IF cl_chk_act_auth() THEN
               CALL q100_show()
            END IF
         WHEN "details"
            IF cl_chk_act_auth() THEN
               CALL q100_runq110()
            END IF
         WHEN "query_sub"
            IF cl_chk_act_auth() THEN
               CALL q100_querysub()
            END IF
         WHEN "query_diff"
            IF cl_chk_act_auth() THEN
               CALL q100_diff()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q100_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            LET w = ui.Window.getCurrent()
            LET f = w.getForm()
            IF cl_chk_act_auth() THEN
               #LET page = f.FindNode("Page","page01")
               #CALL cl_export_to_excel(page,base.TypeInfo.create(g_cki),'','')
               IF l_detail = '1' THEN 
                  LET page = f.FindNode("Page","page01")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_cki),'','')   #No.MOD-D60055 ccc -->cki
               END IF 
               IF l_detail = '2' THEN 
                  LET page = f.FindNode("Page","page02")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_aeh),'','')
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q100_q()
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL q100_curs()                      
   IF INT_FLAG THEN                       
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      RETURN
   END IF
   CALL q100_show()               
END FUNCTION
 
FUNCTION q100_show()          
   CALL q100_b_fill()                
END FUNCTION
 
FUNCTION q100_b_fill()               
DEFINE   p_wc        STRING,
         l_sql       STRING,      
         l_qty1,l_qty2       LIKE ogb_file.ogb12,
         l_tot1,l_tot2       LIKE ogb_file.ogb14,
         l_tot5_tmp  LIKE ccc_file.ccc23 
DEFINE   l_sum1      LIKE abb_file.abb07
DEFINE   l_sum2      LIKE abb_file.abb07
#MOD-DB0096 add sta----------------------------
DEFINE   qc_aah04    LIKE aah_file.aah04,
         qc_aah04_1  LIKE aah_file.aah04,
         qc_aah04_2  LIKE aah_file.aah04,
         qc_aah05    LIKE aah_file.aah05,
         qc_aah05_1  LIKE aah_file.aah05,
         qc_aah05_2  LIKE aah_file.aah05,
         qj_aah04    LIKE aah_file.aah04,
         qj_aah04_1  LIKE aah_file.aah04,
         qj_aah04_2  LIKE aah_file.aah04,
         qj_aah05    LIKE aah_file.aah05,
         qj_aah05_1  LIKE aah_file.aah05,
         qj_aah05_2  LIKE aah_file.aah05
#MOD-DB0096 add end----------------------------
         
   CALL g_cki.clear()
   CALL g_cki_attr.clear()
   CALL g_aeh.clear()
   CALL g_aeh_attr.clear()
   LET g_cnt = 1
   
   LET l_sql = "SELECT cki01,cki02,'','','','','','',cki03 FROM cki_file ORDER BY cki01"
   PREPARE q100_pre1 FROM l_sql
   IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE q100_curs1 CURSOR FOR q100_pre1

   FOREACH q100_curs1 INTO g_cki[g_cnt].*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF  
      IF g_ccz.ccz31 = '1' AND g_cki[g_cnt].cki01 = '7' THEN 
         INITIALIZE g_cki[g_cnt].* TO NULL
      #   LET g_cnt = g_cnt - 1
         CONTINUE FOREACH                  
      END IF
      CALL q100_tot(g_cki[g_cnt].cki01)  
      CALL q100_detail(g_cki[g_cnt].cki01)
      LET l_qty1=g_cki[g_cnt].qty1   LET l_qty2=g_cki[g_cnt].qty2
      LET l_tot1=g_cki[g_cnt].tot1   LET l_tot2=g_cki[g_cnt].tot2
      IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
      IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
      IF cl_null(l_tot1) THEN LET l_tot1=0 END IF
      IF cl_null(l_tot2) THEN LET l_tot2=0 END IF
      LET g_cki[g_cnt].qty3 = l_qty1-l_qty2    #g_cki[g_cnt].qty1 - g_cki[g_cnt].qty2
      LET g_cki[g_cnt].tot3 = l_tot1-l_tot2    #g_cki[g_cnt].tot1 - g_cki[g_cnt].tot2
      IF NOT(g_cnt=1 OR g_cnt=15 OR g_cnt=32) THEN 
         IF cl_null(g_cki[g_cnt].qty3) THEN LET g_cki[g_cnt].qty3=0 END IF
         IF cl_null(g_cki[g_cnt].tot3) THEN LET g_cki[g_cnt].tot3=0 END IF
      END IF
      IF g_ccz.ccz31 = '1' THEN
         IF g_cnt=1 OR g_cnt=15 OR g_cnt=32 THEN 
            LET g_cki_attr[g_cnt].cki01 = "blue reverse"
            LET g_cki_attr[g_cnt].cki02 = "blue reverse"
            LET g_cki_attr[g_cnt].qty1 =  "blue reverse"
            LET g_cki_attr[g_cnt].tot1 =  "blue reverse"
            LET g_cki_attr[g_cnt].qty2 =  "blue reverse"
            LET g_cki_attr[g_cnt].tot2 =  "blue reverse"
            LET g_cki_attr[g_cnt].qty3 =  "blue reverse"
            LET g_cki_attr[g_cnt].tot3 =  "blue reverse"
            LET g_cki_attr[g_cnt].cki03 = "blue reverse"
         END IF 
      ELSE
         IF g_cnt=1 OR g_cnt=16 OR g_cnt=33 THEN 
            LET g_cki_attr[g_cnt].cki01 = "blue reverse"
            LET g_cki_attr[g_cnt].cki02 = "blue reverse"
            LET g_cki_attr[g_cnt].qty1 =  "blue reverse"
            LET g_cki_attr[g_cnt].tot1 =  "blue reverse"
            LET g_cki_attr[g_cnt].qty2 =  "blue reverse"
            LET g_cki_attr[g_cnt].tot2 =  "blue reverse"
            LET g_cki_attr[g_cnt].qty3 =  "blue reverse"
            LET g_cki_attr[g_cnt].tot3 =  "blue reverse"
            LET g_cki_attr[g_cnt].cki03 = "blue reverse"
         END IF 
      END IF 
      IF NOT cl_null(g_cki[g_cnt].qty3) AND g_cki[g_cnt].qty3<>0 THEN 
         LET g_cki_attr[g_cnt].qty3 = "yellow reverse "
      END IF 
      IF NOT cl_null(g_cki[g_cnt].tot3) AND g_cki[g_cnt].tot3<>0 THEN 
         LET g_cki_attr[g_cnt].tot3 = "yellow reverse "
      END IF 
      #FUN-D10107--add--str--
      IF g_lang ='0' THEN
         LET g_cki[g_cnt].cki02 = cl_trans_utf8_twzh(g_lang,g_cki[g_cnt].cki02)
         LET g_cki[g_cnt].cki02 = cl_replace_str(g_cki[g_cnt].cki02,g_replace_1,g_replace_0)
      END IF
      #FUN-D10107--add--end--
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_cki.deleteElement(g_cnt)

   FOR g_cnt1=1 TO 3
      CASE g_cnt1
         WHEN '1'
            LET g_aeh[g_cnt1].aeh04 = cl_getmsg('axc-128',g_lang)
            SELECT sum(ckk08) INTO l_tot5_tmp FROM ckk_file 
             WHERE ckk01 IN ('102') 
               AND ckk03 = tm.yy AND ckk04 = tm.mm
               AND (ckk06 = tm.type OR ckk06=' ') AND ckkacti = 'Y' 
            IF cl_null(l_tot5_tmp) THEN LET l_tot5_tmp=0 END IF 
            LET g_aeh[g_cnt1].tot5 = l_tot5_tmp
            LET l_tot5_tmp = 0
            SELECT sum(ckk11) INTO l_tot5_tmp FROM ckk_file
             WHERE ckk01 IN ('202')       
               AND ckk03 = tm.yy AND ckk04 = tm.mm
               AND (ckk06 = tm.type OR ckk06=' ') AND ckkacti = 'Y'
            IF cl_null(l_tot5_tmp) THEN LET l_tot5_tmp=0 END IF 
            LET g_aeh[g_cnt1].tot5 = l_tot5_tmp+g_aeh[g_cnt1].tot5

        #    SELECT sum(aba08-aba09) INTO g_aeh[g_cnt1].tot4 FROM aba_file 
        #      WHERE aba03 = tm.yy AND aba04 = tm.mm AND aba06='AP'
        #        AND aba00 IN (SELECT ckb01 FROM ckb_file WHERE ckb04='Y')
             SELECT sum(abb07) INTO l_sum1 FROM aba_file,abb_file 
              WHERE aba00 = abb00 AND aba01 = abb01  
                AND aba03 = tm.yy AND aba04 = tm.mm AND aba06='AP'
                AND exists (SELECT 1 FROM ckb_file WHERE abb00 = ckb01 AND abb03 = ckb03 AND ckb04='Y')
                AND abb06 = '1'
             SELECT sum(abb07) INTO l_sum2 FROM aba_file,abb_file 
              WHERE aba00 = abb00 AND aba01 = abb01  
                AND aba03 = tm.yy AND aba04 = tm.mm AND aba06='AP'
                AND exists (SELECT 1 FROM ckb_file WHERE abb00 = ckb01 AND abb03 = ckb03 AND ckb04='Y')
                AND abb06 = '2'  
             LET g_aeh[g_cnt1].tot4 = l_sum1 - l_sum2    
            
         WHEN '2' 
            LET g_aeh[g_cnt1].aeh04 = cl_getmsg('axc-129',g_lang)
            SELECT sum(ckk08) INTO g_aeh[g_cnt1].tot5 FROM ckk_file 
             WHERE ckk01 = '214'
               AND ckk03 = tm.yy AND ckk04 = tm.mm
               AND (ckk06 = tm.type OR ckk06=' ') AND ckkacti = 'Y' 
         #   SELECT sum(aeh11-aeh12) INTO g_aeh[g_cnt1].tot4 FROM aeh_file 
         #     WHERE aeh09 = tm.yy AND aeh10 = tm.mm
         #       AND aeh00 IN (SELECT ckb01 FROM ckb_file 
         #                      WHERE ckb02='2' AND ckb04='Y')

         #MOD-DB0096 mark begin---------------------------------------------
         #   SELECT sum(aeh11-aeh12) INTO g_aeh[g_cnt1].tot4 FROM aeh_file 
         #     WHERE aeh09 = tm.yy AND aeh10 = tm.mm
         #       AND exists (SELECT 1 FROM ckb_file WHERE aeh00 = ckb01 AND aeh01 = ckb03 AND ckb02 = '2' AND ckb04='Y')  
         #MOD-DB0096 mark end-----------------------------------------------
         #MOD-DB0096 add begin----------------------------------------------
         LET qc_aah04_1 = 0
         LET qc_aah05_1 = 0
         LET qc_aah04_2 = 0
         LET qc_aah05_2 = 0
         LET qj_aah04_1 = 0
         LET qj_aah05_1 = 0
         LET qj_aah04_2 = 0
         LET qj_aah05_2 = 0
         #取期初(1)
         SELECT SUM(aah04),SUM(aah05) INTO qc_aah04_1,qc_aah05_1 FROM aah_file WHERE aah02 = tm.yy AND aah03 < tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE aah00 = ckb01 AND aah01 = ckb03 AND ckb02 = '2' AND ckb04='Y') 
         IF cl_null(qc_aah04_1) THEN LET qc_aah04_1 = 0 END IF
         IF cl_null(qc_aah05_1) THEN LET qc_aah05_1 = 0 END IF
         #取期初(2)
         SELECT SUM(abb07) INTO qc_aah04_2 FROM aba_file,abb_file  WHERE aba00 = abb00 AND aba01 = abb01      
            AND aba03 = tm.yy AND abb06 = 1 AND aba19 <> 'X' AND abaacti = 'Y' AND aba19 = 1 AND aba04 < tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE abb00 = ckb01 AND abb03 = ckb03 AND ckb02 = '2' AND ckb04='Y') 
         SELECT SUM(abb07) INTO qc_aah05_2 FROM aba_file,abb_file  WHERE aba00 = abb00 AND aba01 = abb01      
            AND aba03 = tm.yy AND abb06 = 1 AND aba19 <> 'X' AND abaacti = 'Y' AND aba19 = 2 AND aba04 < tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE abb00 = ckb01 AND abb03 = ckb03 AND ckb02 = '2' AND ckb04='Y') 
         IF cl_null(qc_aah04_2) THEN LET qc_aah04_2 = 0 END IF
         IF cl_null(qc_aah05_2) THEN LET qc_aah05_2 = 0 END IF

         LET qc_aah04 = qc_aah04_1 + qc_aah04_2
         LET qc_aah05 = qc_aah05_1 + qc_aah05_2
         
         #取期间异动(1)
         SELECT SUM(aah04),SUM(aah05) INTO qj_aah04_1,qj_aah05_1 FROM aah_file WHERE aah02 = tm.yy AND aah03 = tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE aah00 = ckb01 AND aah01 = ckb03 AND ckb02 = '2' AND ckb04='Y') 
         IF cl_null(qj_aah04_1) THEN LET qj_aah04_1 = 0 END IF
         IF cl_null(qj_aah05_1) THEN LET qj_aah05_1 = 0 END IF
         #取期间异动(2)
         SELECT SUM(abb07) INTO qj_aah04_2 FROM aba_file,abb_file  WHERE aba00 = abb00 AND aba01 = abb01      
            AND aba03 = tm.yy AND abb06 = 1 AND aba19 <> 'X' AND abaacti = 'Y' AND aba19 = 1 AND aba04 = tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE abb00 = ckb01 AND abb03 = ckb03 AND ckb02 = '2' AND ckb04='Y') 
         SELECT SUM(abb07) INTO qj_aah05_2 FROM aba_file,abb_file  WHERE aba00 = abb00 AND aba01 = abb01      
            AND aba03 = tm.yy AND abb06 = 1 AND aba19 <> 'X' AND abaacti = 'Y' AND aba19 = 2 AND aba04 = tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE abb00 = ckb01 AND abb03 = ckb03 AND ckb02 = '2' AND ckb04='Y') 
         IF cl_null(qj_aah04_2) THEN LET qj_aah04_2 = 0 END IF
         IF cl_null(qj_aah05_2) THEN LET qj_aah05_2 = 0 END IF

         LET qj_aah04 = qj_aah04_1 + qj_aah04_2
         LET qj_aah05 = qj_aah05_1 + qj_aah05_2
         LET g_aeh[g_cnt1].tot4 = (qc_aah04+qj_aah04) - (qc_aah05+qj_aah05)
         #MOD-DB0096 add end------------------------------------------------
              
         WHEN '3' 
            LET g_aeh[g_cnt1].aeh04 = cl_getmsg('axc-130',g_lang)
            SELECT sum(ckk08) INTO g_aeh[g_cnt1].tot5 FROM ckk_file 
             WHERE ckk01 = '116'
               AND ckk03 = tm.yy AND ckk04 = tm.mm
               AND (ckk06 = tm.type OR ckk06=' ') AND ckkacti = 'Y' 
         #   SELECT sum(aeh11-aeh12) INTO g_aeh[g_cnt1].tot4 FROM aeh_file 
         #     WHERE aeh09 = tm.yy AND aeh10 = tm.mm
         #       AND aeh00 IN (SELECT ckb01 FROM ckb_file 
         #                      WHERE ckb02='1' AND ckb04='Y')
         #MOD-DB0096 mark begin---------------------------------------------
         #   SELECT sum(aeh11-aeh12) INTO g_aeh[g_cnt1].tot4 FROM aeh_file 
         #     WHERE aeh09 = tm.yy AND aeh10 = tm.mm
         #       AND exists (SELECT 1 FROM ckb_file WHERE aeh00 = ckb01 AND aeh01 = ckb03 AND ckb02 = '1' AND ckb04='Y')
         #MOD-DB0096 mark end-----------------------------------------------
         #MOD-DB0096 add begin----------------------------------------------
         LET qc_aah04_1 = 0
         LET qc_aah05_1 = 0
         LET qc_aah04_2 = 0
         LET qc_aah05_2 = 0
         LET qj_aah04_1 = 0
         LET qj_aah05_1 = 0
         LET qj_aah04_2 = 0
         LET qj_aah05_2 = 0
         #取期初(1)
         SELECT SUM(aah04),SUM(aah05) INTO qc_aah04_1,qc_aah05_1 FROM aah_file WHERE aah02 = tm.yy AND aah03 < tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE aah00 = ckb01 AND aah01 = ckb03 AND ckb02 = '1' AND ckb04='Y') 
         IF cl_null(qc_aah04_1) THEN LET qc_aah04_1 = 0 END IF
         IF cl_null(qc_aah05_1) THEN LET qc_aah05_1 = 0 END IF
         #取期初(2)
         SELECT SUM(abb07) INTO qc_aah04_2 FROM aba_file,abb_file  WHERE aba00 = abb00 AND aba01 = abb01      
            AND aba03 = tm.yy AND abb06 = 1 AND aba19 <> 'X' AND abaacti = 'Y' AND aba19 = 1 AND aba04 < tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE abb00 = ckb01 AND abb03 = ckb03 AND ckb02 = '1' AND ckb04='Y') 
         SELECT SUM(abb07) INTO qc_aah05_2 FROM aba_file,abb_file  WHERE aba00 = abb00 AND aba01 = abb01      
            AND aba03 = tm.yy AND abb06 = 1 AND aba19 <> 'X' AND abaacti = 'Y' AND aba19 = 2 AND aba04 < tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE abb00 = ckb01 AND abb03 = ckb03 AND ckb02 = '1' AND ckb04='Y') 
         IF cl_null(qc_aah04_2) THEN LET qc_aah04_2 = 0 END IF
         IF cl_null(qc_aah05_2) THEN LET qc_aah05_2 = 0 END IF

         LET qc_aah04 = qc_aah04_1 + qc_aah04_2
         LET qc_aah05 = qc_aah05_1 + qc_aah05_2
         
         #取期间异动(1)
         SELECT SUM(aah04),SUM(aah05) INTO qj_aah04_1,qj_aah05_1 FROM aah_file WHERE aah02 = tm.yy AND aah03 = tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE aah00 = ckb01 AND aah01 = ckb03 AND ckb02 = '1' AND ckb04='Y') 
         IF cl_null(qj_aah04_1) THEN LET qj_aah04_1 = 0 END IF
         IF cl_null(qj_aah05_1) THEN LET qj_aah05_1 = 0 END IF
         #取期间异动(2)
         SELECT SUM(abb07) INTO qj_aah04_2 FROM aba_file,abb_file  WHERE aba00 = abb00 AND aba01 = abb01      
            AND aba03 = tm.yy AND abb06 = 1 AND aba19 <> 'X' AND abaacti = 'Y' AND aba19 = 1 AND aba04 = tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE abb00 = ckb01 AND abb03 = ckb03 AND ckb02 = '1' AND ckb04='Y') 
         SELECT SUM(abb07) INTO qj_aah05_2 FROM aba_file,abb_file  WHERE aba00 = abb00 AND aba01 = abb01      
            AND aba03 = tm.yy AND abb06 = 1 AND aba19 <> 'X' AND abaacti = 'Y' AND aba19 = 2 AND aba04 = tm.mm
            AND exists (SELECT 1 FROM ckb_file WHERE abb00 = ckb01 AND abb03 = ckb03 AND ckb02 = '1' AND ckb04='Y') 
         IF cl_null(qj_aah04_2) THEN LET qj_aah04_2 = 0 END IF
         IF cl_null(qj_aah05_2) THEN LET qj_aah05_2 = 0 END IF

         LET qj_aah04 = qj_aah04_1 + qj_aah04_2
         LET qj_aah05 = qj_aah05_1 + qj_aah05_2
         LET g_aeh[g_cnt1].tot4 = (qc_aah04+qj_aah04) - (qc_aah05+qj_aah05)
         #MOD-DB0096 add end------------------------------------------------
              
      END CASE 
      LET g_aeh[g_cnt1].tot6 = g_aeh[g_cnt1].tot4 - g_aeh[g_cnt1].tot5
      IF NOT cl_null(g_aeh[g_cnt1].tot6) AND g_aeh[g_cnt1].tot6<>0 THEN 
         LET g_aeh_attr[g_cnt1].tot6 = "yellow reverse"
      END IF 
   END FOR    
   LET g_cnt = g_cnt-1
   LET g_cnt1 = g_cnt1-1
END FUNCTION
 
FUNCTION q100_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY BY NAME tm.*
   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)
      DISPLAY ARRAY g_cki TO s_cki.*
         BEFORE DISPLAY
            LET l_detail = '1'
            CALL DIALOG.setArrayAttributes("s_cki",g_cki_attr)   
         BEFORE ROW
            DISPLAY g_cnt TO cn2
            LET l_detail = '1'
            LET l_ac = ARR_CURR()
      END DISPLAY
      DISPLAY ARRAY g_aeh TO s_aeh.* 
         BEFORE DISPLAY
            LET l_detail = '2'
            CALL DIALOG.setArrayAttributes("s_aeh",g_aeh_attr) 
         BEFORE ROW
            DISPLAY g_cnt1 TO cn2
            LET l_detail = '2'
            LET l_ac1 = ARR_CURR()
      END DISPLAY

  #    ON ACTION details 
  #       LET g_action_choice="details"
  #       EXIT DIALOG 

      ON ACTION query_sub 
         #LET g_action_choice="query_sub"
         #EXIT DIALOG 
         CALL q100_querysub()
         CONTINUE DIALOG

      ON ACTION fresh
         LET g_action_choice="fresh"
         EXIT DIALOG

      ON ACTION query_diff
         #LET g_action_choice="query_diff"
         #EXIT DIALOG
         CALL q100_diff()
         CONTINUE DIALOG
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL q100_show()  #FUN-D10107
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about      
         CALL cl_about()  
   
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")       
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q100_tot(p_cki01)  #總表兩列數據填充 [數量/金錢]
   DEFINE p_cki01 LIKE cki_file.cki01
   DEFINE l_ckk01 STRING 
   DEFINE l_ckk07 LIKE ckk_file.ckk07
   DEFINE l_ckk08 LIKE ckk_file.ckk08
   DEFINE l_sql   STRING 

   IF p_cki01 <> 1 AND p_cki01 <> 16 AND p_cki01 <> 32 AND p_cki01 <> 33 THEN 
      CASE p_cki01  
         #庫存
         WHEN '2'  LET l_ckk01 = '103'    #庫存開賬調整
         WHEN '3'  LET l_ckk01 = '101'    #期初庫存
         WHEN '4'  LET l_ckk01 = '102'    #一般採購
         WHEN '5'  LET l_ckk01 = '104'    #雜項入庫
         WHEN '6'  LET l_ckk01 = "105','115','117"  #工單入庫
         WHEN '7'  LET l_ckk01 = '112'    #銷退入庫
         WHEN '8'  LET l_ckk01 = '106'    #入庫調整
         WHEN '9'  LET l_ckk01 = '107'    #工單發料
         WHEN '10' LET l_ckk01 = '108'    #雜項發料
         WHEN '11' LET l_ckk01 = '109'    #盤盈虧
         WHEN '12' LET l_ckk01 = '110'    #銷貨成本
         WHEN '13' LET l_ckk01 = '111'    #樣品出貨
         WHEN '14' LET l_ckk01 = '113'    #結存調整
         WHEN '15' LET l_ckk01 = '116'    #期末庫存
         #在制
         WHEN '17' LET l_ckk01 = '215'    #在制開賬調整
         WHEN '18' LET l_ckk01 = '201'    #期初在制
         WHEN '19' LET l_ckk01 = '202'    #在制投入合计(原料+半成品)
         WHEN '28' LET l_ckk01 = '210'    #在制調整
         WHEN '29' LET l_ckk01 = '211'    #在制轉出
         WHEN '30' LET l_ckk01 = '212'    #差異轉出
         WHEN '31' LET l_ckk01 = '213'    #拆件差異
         #其他
         WHEN '34' LET l_ckk01 = '317'    #銷貨收入明細表
         WHEN '35' LET l_ckk01 = '318'    #採購入庫金額
         OTHERWISE LET l_ckk01 = ''
      END CASE 
      IF NOT cl_null(l_ckk01) THEN 
         LET l_sql =" SELECT SUM(ckk07),SUM(ckk08) FROM ckk_file ",
                    "  WHERE ckk01 IN ('" ,l_ckk01,"') ",
                   #"    AND ckk03 = '" ,tm.yy,"' ",
                   #"    AND ckk04 = '" ,tm.mm,"' ",
                    "    AND ckk03 = " ,tm.yy,      #MOD-DB0013
                    "    AND ckk04 = " ,tm.mm,      #MOD-DB0013
                    "    AND (ckk06 = '" ,tm.type,"' OR ckk06=' ')",
                    "    AND ckkacti = 'Y' "
         PREPARE q100_pre01 FROM l_sql
         DECLARE q100_cs01 CURSOR FOR q100_pre01
         FOREACH q100_cs01 INTO l_ckk07,l_ckk08
            EXIT FOREACH 
         END FOREACH 
      END IF
      CASE p_cki01
         WHEN '20'     #在制投入-直接人工
            SELECT ckk09 INTO l_ckk08 FROM ckk_file
             WHERE ckk01='202' AND ckkacti='Y'
               AND ckk03=tm.yy AND ckk04=tm.mm
               AND (ckk06=tm.type OR ckk06=' ')
         WHEN '21'     #在制投入-直接人工
            SELECT ckk10 INTO l_ckk08 FROM ckk_file
             WHERE ckk01='202' AND ckkacti='Y'
               AND ckk03=tm.yy AND ckk04=tm.mm
               AND (ckk06=tm.type OR ckk06=' ')
         WHEN '22'     #在制投入-制費1
            SELECT ckk12 INTO l_ckk08 FROM ckk_file
             WHERE ckk01='202' AND ckkacti='Y'
               AND ckk03=tm.yy AND ckk04=tm.mm
               AND (ckk06=tm.type OR ckk06=' ')
         WHEN '23'     #在制投入-制費2
            SELECT ckk13 INTO l_ckk08 FROM ckk_file
             WHERE ckk01='202' AND ckkacti='Y'
               AND ckk03=tm.yy AND ckk04=tm.mm
               AND (ckk06=tm.type OR ckk06=' ')
         WHEN '24'     #在制投入-制費3
            SELECT ckk14 INTO l_ckk08 FROM ckk_file
             WHERE ckk01='202' AND ckkacti='Y'
               AND ckk03=tm.yy AND ckk04=tm.mm
               AND (ckk06=tm.type OR ckk06=' ')
         WHEN '25'     #在制投入-制費4
            SELECT ckk15 INTO l_ckk08 FROM ckk_file
             WHERE ckk01='202' AND ckkacti='Y'
               AND ckk03=tm.yy AND ckk04=tm.mm
               AND (ckk06=tm.type OR ckk06=' ')
         WHEN '26'     #在制投入-制費5
            SELECT ckk16 INTO l_ckk08 FROM ckk_file
             WHERE ckk01='202' AND ckkacti='Y'
               AND ckk03=tm.yy AND ckk04=tm.mm
               AND (ckk06=tm.type OR ckk06=' ')
         WHEN '27'     #在制投入-加工費
            SELECT ckk11 INTO l_ckk08 FROM ckk_file
             WHERE ckk01='202' AND ckkacti='Y'
               AND ckk03=tm.yy AND ckk04=tm.mm
               AND (ckk06=tm.type OR ckk06=' ')
      END CASE 
      LET g_cki[g_cnt].qty1 = l_ckk07
      LET g_cki[g_cnt].tot1 = l_ckk08
      IF p_cki01=14 OR p_cki01=20 OR p_cki01=21 OR p_cki01=22 OR p_cki01=23 OR p_cki01=24 OR 
         p_cki01=25 OR p_cki01=26 OR p_cki01=27 OR p_cki01=29 OR p_cki01=30 OR p_cki01=31 THEN  
         LET g_cki[g_cnt].qty1 = ''
      END IF 
   ELSE 
      IF p_cki01 = '32' THEN              #期末在制
        #MOD-D90047 modify begin-----------------------------------
        #LET l_sql =" SELECT sum(ccg91),sum(ccg92) FROM ccg_file ",
        #           "  WHERE ccg02 = '" ,tm.yy,"' ",
        #           "    AND ccg03 = '" ,tm.mm,"' ",
        #           "    AND ccg06 = '" ,tm.type,"' "
         LET l_sql =" SELECT sum(cch91),sum(cch92) FROM cch_file ",
                    "  WHERE cch02 = '" ,tm.yy,"' ",
                    "    AND cch03 = '" ,tm.mm,"' ",
                    "    AND cch06 = '" ,tm.type,"' "
        #MOD-D90047 modify end-------------------------------------
         PREPARE q100_pre02 FROM l_sql
         DECLARE q100_cs02 CURSOR FOR q100_pre02
         OPEN q100_cs02
         FETCH q100_cs02 INTO g_cki[g_cnt].qty1,g_cki[g_cnt].tot1
      END IF 
   END IF 
END FUNCTION 

FUNCTION q100_detail(p_cki01)  #明細表兩列數據填充 [數量/金錢]
   DEFINE p_cki01 LIKE cki_file.cki01
   DEFINE l_ckk01 STRING
   DEFINE l_ckk07 LIKE ckk_file.ckk07
   DEFINE l_ckk08 LIKE ckk_file.ckk08
   DEFINE l_sql   STRING 
   DEFINE l_pre_yy  LIKE type_file.num5  #上期年度
   DEFINE l_pre_mm  LIKE type_file.num5  #上期期別

   IF tm.mm > 1 THEN 
      LET l_pre_yy = tm.yy
      LET l_pre_mm = tm.mm-1
   ELSE
      IF tm.mm = 1 THEN 
         LET l_pre_yy = tm.yy-1
         LET l_pre_mm = 12 
      END IF
   END IF
   IF p_cki01 <> 1 AND p_cki01 <> 16 AND p_cki01 <> 33 THEN 
      CASE p_cki01  
         #庫存
         WHEN '4'  LET l_ckk01 = '303'      #一般採購
         WHEN '5'  LET l_ckk01 = "301"      #雜項入庫
         WHEN '6'  LET l_ckk01 = '307'      #工單入庫
         WHEN '7'                           #銷退入庫
            IF g_ccz.ccz31 MATCHES '[23]' THEN LET l_ckk01 = '311' 
            ELSE LET l_ckk01 = '0' END IF 
         WHEN '8'  LET l_ckk01 = '308'      #入庫調整
         WHEN '9'  LET l_ckk01 = '306'      #工單發料
         WHEN '10' LET l_ckk01 = "302"      #雜項發料
         WHEN '11' LET l_ckk01 = '316'      #盤盈虧
         WHEN '12'                          #銷貨成本
            IF g_ccz.ccz31 MATCHES '[1]' THEN LET l_ckk01 = "310','311" 
            ELSE LET l_ckk01 = '310' END IF 
         WHEN '13' LET l_ckk01 = '321'      #樣品出貨
         WHEN '14' LET l_ckk01 = '113'      #結存調整
         #在制
         WHEN '19' LET l_ckk01 = '306'      #在制投入合计(原料+半成品)
         WHEN '27' LET l_ckk01 = "304','305"  #在制投入-加工費
         WHEN '29' LET l_ckk01 = '307'      #在制轉出
         WHEN '30' LET l_ckk01 = '212'      #差異轉出
         WHEN '31' LET l_ckk01 = '213'      #拆件差異
         #其他
         WHEN '34' LET l_ckk01 = '312'      #銷貨收入明細表
         WHEN '35' LET l_ckk01 = "303','304','305" #採購入庫金額
         OTHERWISE LET l_ckk01 = ''
      END CASE 
      IF NOT cl_null(l_ckk01) THEN 
         LET l_sql =" SELECT sum(ckk07),sum(ckk08) FROM ckk_file ",
                    "  WHERE ckk01 IN ('" ,l_ckk01,"') ",
                   #"    AND ckk03 = '" ,tm.yy,"' ",
                   #"    AND ckk04 = '" ,tm.mm,"' ",
                    "    AND ckk03 = " ,tm.yy,     #MOD-DB0013
                    "    AND ckk04 = " ,tm.mm,     #MOD-DB0013
                    "    AND (ckk06 = '" ,tm.type,"' OR ckk06=' ')",
                    "    AND ckkacti = 'Y' "
         PREPARE q100_pre03 FROM l_sql
         DECLARE q100_cs03 CURSOR FOR q100_pre03
         FOREACH q100_cs03 INTO l_ckk07,l_ckk08
            EXIT FOREACH 
         END FOREACH 
      END IF 
      LET g_cki[g_cnt].qty2 = l_ckk07
      LET g_cki[g_cnt].tot2 = l_ckk08
      IF p_cki01 = '19' OR p_cki01 = '20' OR p_cki01 = '29' THEN 
         LET g_cki[g_cnt].qty2 = l_ckk07 * -1
         LET g_cki[g_cnt].tot2 = l_ckk08 * -1
      END IF  
      LET l_sql = ''
      CASE p_cki01
         WHEN '2'                           #庫存開賬調整
            LET l_sql =" SELECT NVL(sum(cca11),0)-NVL(sum(ccc91),0),NVL(sum(cca12),0)-NVL(sum(ccc92),0) ",
                       "   FROM cca_file LEFT OUTER JOIN ccc_file ON cca01=ccc01 AND cca02=ccc02 AND cca03=ccc03 AND cca06=ccc07 AND cca07=ccc08 ",
                       "  WHERE cca02 = '" ,l_pre_yy,"' ",
                       "    AND cca03 = '" ,l_pre_mm,"' ",
                       "    AND cca06 = '" ,tm.type,"' "
         WHEN '3'  LET l_ckk01 = '101'      #期初庫存
            LET l_sql =" SELECT sum(ccc91),sum(ccc92) FROM ccc_file ",
                       "  WHERE ccc02 = '" ,l_pre_yy,"' ",
                       "    AND ccc03 = '" ,l_pre_mm,"' ",
                       "    AND ccc07 = '" ,tm.type,"' "
         WHEN '15'                          #期末庫存
            LET l_sql =" SELECT sum(ccc11+ccc21+ccc25+ccc27+ccc31+ccc41+ccc51+ccc61+ccc71) ",
                       "       ,sum(ccc12+ccc22+ccc26+ccc28+ccc32+ccc42+ccc52+ccc62+ccc72+ccc93) ", 
                       "   FROM ccc_file ",
                       "  WHERE ccc02 = '" ,tm.yy,"' ",
                       "    AND ccc03 = '" ,tm.mm,"' ",
                       "    AND ccc07 = '" ,tm.type,"' "
         WHEN '17'                          #在制開賬調整
            LET l_sql =" SELECT sum(ccf11),sum(ccf12) FROM ccf_file ",
                       "  WHERE ccf02 = '" ,l_pre_yy,"' ",
                       "    AND ccf03 = '" ,l_pre_mm,"' ",
                       "    AND ccf06 = '" ,tm.type,"' ",
                       "    AND ccfacti = 'Y' "
         WHEN '18'                          #期初在制
          #  LET l_sql =" SELECT sum(ccg91),sum(ccg92) FROM ccg_file ",
          #             "  WHERE ccg02 = '" ,l_pre_yy,"' ",
          #             "    AND ccg03 = '" ,l_pre_mm,"' ",
          #             "    AND ccg06 = '" ,tm.type,"' "  
            LET l_sql =" SELECT sum(cch91),sum(cch92) FROM cch_file ",
                       "  WHERE cch02 = '" ,l_pre_yy,"' ",
                       "    AND cch03 = '" ,l_pre_mm,"' ",
                       "    AND cch06 = '" ,tm.type,"' "
         WHEN '21'                          #在制投入-直接人工
            LET l_sql =" SELECT '',sum(cmi08) FROM cmi_file ",
                       "  WHERE cmi01 = '" ,tm.yy,"' ",
                       "    AND cmi02 = '" ,tm.mm,"' ",
                       "    AND cmi04 = '1' "
         WHEN '22'                          #在制投入-制費1
            LET l_sql =" SELECT '',sum(cmi08) FROM cmi_file ",
                       "  WHERE cmi01 = '" ,tm.yy,"' ",
                       "    AND cmi02 = '" ,tm.mm,"' ",
                       "    AND cmi04 = '2' "  
         WHEN '23'                          #在制投入-制費2
            LET l_sql =" SELECT '',sum(cmi08) FROM cmi_file ",
                       "  WHERE cmi01 = '" ,tm.yy,"' ",
                       "    AND cmi02 = '" ,tm.mm,"' ",
                       "    AND cmi04 = '3' "  
         WHEN '24'                          #在制投入-制費3
            LET l_sql =" SELECT '',sum(cmi08) FROM cmi_file ",
                       "  WHERE cmi01 = '" ,tm.yy,"' ",
                       "    AND cmi02 = '" ,tm.mm,"' ",
                       "    AND cmi04 = '4' " 
         WHEN '25'                          #在制投入-制費4
            LET l_sql =" SELECT '',sum(cmi08) FROM cmi_file ",
                       "  WHERE cmi01 = '" ,tm.yy,"' ",
                       "    AND cmi02 = '" ,tm.mm,"' ",
                       "    AND cmi04 = '5' " 
         WHEN '26'                          #在制投入-制費5
            LET l_sql =" SELECT '',sum(cmi08) FROM cmi_file ",
                       "  WHERE cmi01 = '" ,tm.yy,"' ",
                       "    AND cmi02 = '" ,tm.mm,"' ",
                       "    AND cmi04 = '6' " 
         WHEN '28'                          #在制調整
            LET l_sql =" SELECT cum(ccl21),sum(ccl22) FROM ccl_file ",
                       "  WHERE ccl02 = '" ,tm.yy,"' ",
                       "    AND ccl03 = '" ,tm.mm,"' ",
                       "    AND ccl06 = '" ,tm.type,"' ",
                       "    AND cclacti = 'Y' "
         WHEN '32'                          #期末在制
           #MOD-D90047 modify begin-----------------------------------
           #LET l_sql =" SELECT sum(ccg11+ccg21+ccg31+ccg41) ",
           #           "       ,sum(ccg12+ccg22+ccg23+ccg32+ccg42)  FROM ccg_file ", 
           #           "  WHERE ccg02 = '" ,tm.yy,"' ",
           #           "    AND ccg03 = '" ,tm.mm,"' ",
           #           "    AND ccg06 = '" ,tm.type,"' "
            LET l_sql =" SELECT sum(cch11+cch21+cch31+cch41) ",
                       "       ,sum(cch12+cch22+cch32+cch42)  FROM cch_file ",
                       "  WHERE cch02 = '" ,tm.yy,"' ",
                       "    AND cch03 = '" ,tm.mm,"' ",
                       "    AND cch06 = '" ,tm.type,"' "
           #MOD-D90047 modify end-------------------------------------
      END CASE 
      IF NOT cl_null(l_sql) THEN 
         PREPARE q100_pre04 FROM l_sql
         DECLARE q100_cs04 CURSOR FOR q100_pre04
         OPEN q100_cs04
         FETCH q100_cs04 INTO g_cki[g_cnt].qty2,g_cki[g_cnt].tot2
      END IF 
      IF p_cki01='20' THEN  #在制投入-材料金额
         SELECT ckk09*(-1) INTO g_cki[g_cnt].tot2 FROM ckk_file
          WHERE ckk01='306' AND ckkacti='Y'
            AND ckk03=tm.yy AND ckk04=tm.mm
            AND (ckk06=tm.type OR ckk06=' ')
      END IF 
      IF p_cki01=14 OR p_cki01=20 OR p_cki01=21 OR p_cki01=22 OR p_cki01=23 OR p_cki01=24 OR 
         p_cki01=25 OR p_cki01=26 OR p_cki01=27 OR p_cki01=29 OR p_cki01=30 OR p_cki01=31 THEN  
         LET g_cki[g_cnt].qty2 = ''
      END IF 
   END IF 

END FUNCTION 

FUNCTION q100_runq110()
   DEFINE l_cmd   STRING 
   DEFINE l_cki01 LIKE cki_file.cki01
   DEFINE l_ckk01 STRING 

   IF l_detail = '1' THEN 
      IF NOT cl_null(l_ac) AND l_ac>=1 THEN 
         LET l_cki01 = g_cki[l_ac].cki01
      ELSE 
         RETURN
      END IF
      CASE l_cki01 #除 期末在制
         WHEN '2'  LET l_ckk01 = '103'           #庫存開賬調整
         WHEN '3'  LET l_ckk01 = '101'           #期初庫存
         WHEN '4'  LET l_ckk01 = '102,303'       #一般採購
         WHEN '5'  LET l_ckk01 = '104,301'       #雜項入庫
         WHEN '6'  LET l_ckk01 = '105,115,117,307'       #工單入庫
         WHEN '7'                                #銷退入庫
            IF g_ccz.ccz31 MATCHES '[23]' THEN LET l_ckk01 = '112,311' 
            ELSE LET l_ckk01 = '112,0' END IF 
         WHEN '8'  LET l_ckk01 = '106,308'       #入庫調整
         WHEN '9'  LET l_ckk01 = '107,306'       #工單發料
         WHEN '10' LET l_ckk01 = '108,302'       #雜項發料
         WHEN '11' LET l_ckk01 = '109,316'       #盤盈虧
         WHEN '12' LET l_ckk01 = ''              #銷貨成本
            IF g_ccz.ccz31 MATCHES '[1]' THEN LET l_ckk01 = '110,310,311' 
            ELSE LET l_ckk01 = '110,310' END IF 
         WHEN '13' LET l_ckk01 = '111,321'       #樣品出貨
         WHEN '14' LET l_ckk01 = '113'           #結存調整
         WHEN '15' LET l_ckk01 = '116'           #期末庫存
         #在制
         WHEN '17' LET l_ckk01 = '215'           #在制開賬調整
         WHEN '18' LET l_ckk01 = '201'           #期初在制
         WHEN '19' LET l_ckk01 = '202,306'       #在制投入-(原料+半成品)
         WHEN '20' LET l_ckk01 = '202,306'       #在制投入-材料金额
         WHEN '21' LET l_ckk01 = '202'           #在制投入-直接人工
         WHEN '22' LET l_ckk01 = '202'           #在制投入-制費1
         WHEN '23' LET l_ckk01 = '202'           #在制投入-制費2
         WHEN '24' LET l_ckk01 = '202'           #在制投入-制費3
         WHEN '25' LET l_ckk01 = '202'           #在制投入-制費4
         WHEN '26' LET l_ckk01 = '202'           #在制投入-制費5
         WHEN '27' LET l_ckk01 = '209,304,305'   #在制投入-加工費
         WHEN '28' LET l_ckk01 = '210'           #在制調整
         WHEN '29' LET l_ckk01 = '211,307'       #在制轉出
         WHEN '30' LET l_ckk01 = '212'           #差異轉出
         WHEN '31' LET l_ckk01 = '213'           #拆件差異
         #其他
         WHEN '34' LET l_ckk01 = '317,312'       #銷貨收入明細表
         WHEN '35' LET l_ckk01 = '318,303,304,305'  #採購入庫金額
         OTHERWISE LET l_ckk01 = ''
      END CASE
   END IF 
   IF l_detail = '2' THEN 
      IF cl_null(l_ac1) OR l_ac1<1 THEN 
         RETURN
      END IF
      CASE l_ac1
         WHEN '1' LET l_ckk01 = '102,209'
         WHEN '2' LET l_ckk01 = '214'
         WHEN '3' LET l_ckk01 = '116'
         OTHERWISE EXIT CASE 
      END CASE 
   END IF 
   IF NOT cl_null(l_ckk01) THEN  
      LET l_cmd = " axcq110 '",l_ckk01,"' '",tm.yy,"' '",tm.mm,"' '",tm.type,"' "
      CALL cl_cmdrun(l_cmd)
   END IF 
END FUNCTION

FUNCTION q100_querysub()
   DEFINE l_cmd    STRING
   DEFINE l_cmd1   STRING
   DEFINE l_cki01  LIKE cki_file.cki01
   
   IF l_detail = '1' THEN 
      IF NOT cl_null(l_ac) AND l_ac>=1 THEN 
         LET l_cki01 = g_cki[l_ac].cki01
      ELSE 
         RETURN
      END IF
      LET l_cmd = ''
      LET l_cmd1= ''
      CASE l_cki01 #除 期末在制
         WHEN '4'        #一般採購
            LET l_cmd = "axcq700 '' '' '' 'N' '' '' '' '",tm.yy,"' '",tm.mm,"' '' ",
                        " '' '' '' '' '' '' '",tm.type,"' '' '' '' ",
                        " '' '' '' '' '' '' '' '' '' '' '' "
         WHEN '5'        #雜項入庫
            LET l_cmd = "axcq775 '",tm.yy,"' '",tm.mm,"' '",tm.type,"' '' 'N' "
         WHEN '6'        #工單入庫
            LET l_cmd = "axcq777 '",tm.yy,"' '",tm.mm,"' '",tm.type,"' '' 'N' "
         WHEN '7'        #銷退入庫
            LET l_cmd = "axcq761 '' '' '' 'N' '' '' '' '",tm.yy,"' '",tm.mm,"' '' ",
                        " '' '' '",tm.type,"' '' '' '' '' '' '' '' ",
                        " '' '' '' '' '' '' '' '' '' "
         WHEN '8'        #入庫調整
            LET l_cmd = "axcq002 '' '' '' 'N' '' '' '' '",tm.yy,"' '",tm.mm,"' '' ",
                        " '' '",tm.type,"' '' '' '' '' ''"
         WHEN '9'        #工單發料
            LET l_cmd = "axcq776 '",tm.yy,"' '",tm.mm,"' '",tm.type,"' '' 'N' "
         WHEN '10'       #雜項發料
            LET l_cmd = "axcq775 '",tm.yy,"' '",tm.mm,"' '",tm.type,"' '' 'N' "
         WHEN '11'       #盤盈虧
            LET l_cmd = "aimq998 '",tm.yy,"' '",tm.mm,"' '",tm.type,"' '' 'N' "
         WHEN '12'       #銷貨成本
            LET l_cmd = "axcq761 '' '' '' 'N' '' '' '' '",tm.yy,"' '",tm.mm,"' '' ",
                        " '' '' '",tm.type,"' '' '' '' '' '' '' '' ",
                        " '' '' '' '' '' '' '' '' '' "
         WHEN '13'       #樣品出貨
            LET l_cmd = "axcq761 '' '' '' 'N' '' '' '' '",tm.yy,"' '",tm.mm,"' '' ",
                        " '' '' '",tm.type,"' '' '' '' '' '' '' '' ",
                        " '' '' '' '' '' '' '' '' '' "
         #在制
         WHEN '19'       #在制投入-(原料+半成品)
            LET l_cmd = "axcq776 '",tm.yy,"' '",tm.mm,"' '",tm.type,"' '' 'N' "
         WHEN '20'       #在制投入-材料金额
            LET l_cmd = "axcq776 '",tm.yy,"' '",tm.mm,"' '",tm.type,"' '' 'N' "
         WHEN '27'       #在制投入-加工費
            LET l_cmd = "axcq700 '' '' '' 'N' '' '' '' '",tm.yy,"' '",tm.mm,"' '' ",
                        " '' '' '' '' '' '' '",tm.type,"' '' '' '' ",
                        " '' '' '' '' '' '' '' '' '' '' '' "
         WHEN '29'       #在制轉出
            LET l_cmd = "axcq777 '",tm.yy,"' '",tm.mm,"' '",tm.type,"' '' 'N' "
         #其他
         WHEN '34'       #銷貨收入明細表
            LET l_cmd = "axcq761 '' '' '' 'N' '' '' '' '",tm.yy,"' '",tm.mm,"' '' ",
                        " '' '' '",tm.type,"' '' '' '' '' '' '' '' ",
                        " '' '' '' '' '' '' '' '' '' "
         WHEN '35'       #採購入庫金額
            LET l_cmd = "axcq700 '' '' '' 'N' '' '' '' '",tm.yy,"' '",tm.mm,"' '' ",
                        " '' '' '' '' '' '' '",tm.type,"' '' '' '' ",
                        " '' '' '' '' '' '' '' '' '' '' '' "
         OTHERWISE LET l_cmd='' LET l_cmd1=''
      END CASE
      IF NOT cl_null(l_cmd) THEN  
         CALL cl_cmdrun(l_cmd)
      END IF 
      IF NOT cl_null(l_cmd1) THEN  
         CALL cl_cmdrun(l_cmd1)
      END IF 
   END IF 
END FUNCTION 

FUNCTION q100_diff()

   IF l_detail <> '1' THEN RETURN END IF 
   IF g_cki[l_ac].cki01='1' OR g_cki[l_ac].cki01='16' OR g_cki[l_ac].cki01='33' THEN
      RETURN
   END IF 
   IF (cl_null(g_cki[l_ac].qty3) OR g_cki[l_ac].qty3=0)
      AND (cl_null(g_cki[l_ac].tot3) OR g_cki[l_ac].tot3=0) THEN 
      CALL cl_err(g_cki[l_ac].cki02,'azz1049',1)
      RETURN 
   END IF
   LET g_prog = 'axcq100_1'  
   OPEN WINDOW q100_diff_w WITH FORM "axc/42f/axcq100_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_set_comp_visible('ccc08',g_ccz.ccz28 NOT MATCHES '[1,2]') 
   CALL q100_diff_fill()
   CALL q100_diff_menu()
   CLOSE WINDOW q100_diff_w
   LET g_prog = 'axcq100'  
END FUNCTION 

FUNCTION q100_diff_menu()
   WHILE TRUE
      CALL q100_diff_bp("G")
      CASE g_action_choice
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            LET w = ui.Window.getCurrent()
            LET f = w.getForm()
            IF cl_chk_act_auth() THEN
               LET page = f.FindNode("Page","page1")
               CALL cl_export_to_excel(page,base.TypeInfo.create(g_cki),'','')
            END IF
      END CASE
   END WHILE
   LET g_action_choice = ''
END FUNCTION

FUNCTION q100_diff_fill()
   DEFINE l_cki01   LIKE cki_file.cki01
   DEFINE l_sql     STRING 
   DEFINE l_bdate   LIKE type_file.dat   
   DEFINE l_edate   LIKE type_file.dat   
   DEFINE l_pre_yy  LIKE type_file.num5  #上期年度
   DEFINE l_pre_mm  LIKE type_file.num5  #上期期別


   LET l_sql = ""
   LET l_cki01 = g_cki[l_ac].cki01
   CALL s_azn01(tm.yy,tm.mm) RETURNING l_bdate,l_edate
   IF tm.mm > 1 THEN 
      LET l_pre_yy = tm.yy
      LET l_pre_mm = tm.mm-1
   ELSE
      IF tm.mm = 1 THEN 
         LET l_pre_yy = tm.yy-1
         LET l_pre_mm = 12 
      END IF
   END IF

   IF g_ccz.ccz28 MATCHES '[1,2]' THEN 
      CASE l_cki01 
         WHEN '2'      #庫存開賬調整
         WHEN '3'      #期初庫存
            #xh--modify--str--  #test ok
            #LET l_sql= "SELECT '',A.ccc01,'','',' ',ccc11,NVL(qty,0),'',ccc12,NVL(amt,0),'' ",
            #           "  FROM ccc_file A,(SELECT ccc01,ccc91 qty,ccc92 amt FROM ccc_file  ",
            #           "                  WHERE ccc02=",l_pre_yy," AND ccc03=",l_pre_mm," AND ccc07='",tm.type,"' ) B  ",
            #           " WHERE A.ccc01=B.ccc01(+) AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"'  ",
            #           "   AND (ccc11<>NVL(qty,0) OR ccc12<>NVL(amt,0))  "
            LET l_sql= "SELECT '',A.ccc01,'','',' ',ccc11,NVL(qty,0),'',ccc12,NVL(amt,0),'' ",
                       "  FROM ccc_file A LEFT OUTER JOIN (SELECT ccc01,ccc91 qty,ccc92 amt FROM ccc_file  ",
                       "                  WHERE ccc02=",l_pre_yy," AND ccc03=",l_pre_mm," AND ccc07='",tm.type,"' ) B ON A.ccc01=B.ccc01  ",
                       " WHERE ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"'  ",
                       "   AND (ccc11<>NVL(qty,0) OR ccc12<>NVL(amt,0))  "
            #xh--modify--end--

         WHEN '4'      #一般採購
            LET l_sql= "SELECT '',ccc01,'','',' ',ccc211,qty,'',ccc221,amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01,SUM(tlf10*tlf60*tlf907) qty,SUM(tlf21*tlf907) amt FROM tlf_file ",
                       "                  WHERE tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                    AND (tlf13 = 'apmt150' OR tlf13 = 'apmt1072' OR tlf13 = 'apmt230') ",
                       "                    AND tlf902 NOT IN(SELECT jce02 FROM jce_file)  ",
                       "                  GROUP BY tlf01) bb       ",
                       " WHERE ccc01=tlf01 AND ccc02=",tm.yy,"  AND ccc03=",tm.mm," AND ccc07='",tm.type,"'  ",
                       "   AND (ccc211<>qty OR ccc221<>amt) "

         WHEN '5'      #雜項入庫
            LET l_sql= "SELECT '',ccc01,'','',' ',ccc214,qty,'',ccc224,amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01,SUM(tlf10*tlf60*tlf907) qty,SUM(tlf21*tlf907) amt  FROM tlf_file  ",
                       "                  WHERE tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                    AND tlf13 IN('aimt302','aimt312','aimt306') AND tlf902 NOT IN(SELECT jce02 FROM jce_file) ",
                       "                  GROUP BY tlf01) bb   ",
                       " WHERE ccc01=tlf01 AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND (ccc214<>qty OR ccc224<>amt) "

         WHEN '6'      #工單入庫
            #xh--modify--str--  #test ok
            #LET l_sql= "SELECT '',ccc01,'','',' ',(ccc212+ccc213+ccc27),qty,'',(ccc222+ccc223+ccc28),NVL(amt1,0)+NVL(amt2,0),'' ",
            #           "  FROM ccc_file,(SELECT tlf01,SUM(tlf10*tlf60*tlf907) qty,SUM(tlf907*tlf21) amt1 FROM sfb_file,tlf_file  ",
            #           "                  WHERE sfb01= tlf62 AND sfb02!=11 ",
            #           "                    AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231' OR tlf13='asft660') ",
            #           "                    AND tlf902 NOT IN (SELECT jce02 FROM jce_file)  ",
            #           "                    AND (tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ) ",
            #           "                  GROUP BY tlf01 ), ",
            #           "                 (SELECT ccg04,-1*NVL(SUM(ccg32),0) amt2 FROM ccg_file,sfb_file ",           #在制差异转出
            #           "                   WHERE ccg01=sfb01 AND sfb02!=11 AND ccg32<>0 AND ccg31=0 ",
            #           "                     AND ccg02=",tm.yy," AND ccg03=",tm.mm," AND ccg06='",tm.type,"'  ",
            #           "                   GROUP BY ccg04 )   ",
            #           " WHERE ccc01=tlf01(+) AND ccc01=ccg04(+) AND ccc02=",tm.yy," AND ccc03=",tm.mm,"  AND ccc07='",tm.type,"' ",
            #           "   AND ((ccc212+ccc213+ccc27)<>qty OR (ccc222+ccc223+ccc28)<>NVL(amt1,0)+NVL(amt2,0))"

            LET l_sql= "   SELECT '' ,ccc01,'','',' ',(ccc212+ccc213+ccc27),qty,'',(ccc222+ccc223+ccc28),NVL(amt1,0)+NVL(amt2,0),'' ",
                       "     FROM ccc_file ",
                       "     LEFT OUTER JOIN (SELECT tlf01,SUM(tlf10*tlf60*tlf907) qty,SUM(tlf907*tlf21) amt1 FROM sfb_file,tlf_file  ",
                       "                       WHERE sfb01= tlf62 AND sfb02!=11 ",
                       "                         AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231' OR tlf13='asft660') ",
                       "                         AND tlf902 NOT IN (SELECT jce02 FROM jce_file)  ",
                       "                         AND (tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ) ",
                       "                       GROUP BY tlf01 ) ON ccc01=tlf01 ",
                       "     LEFT OUTER JOIN (SELECT ccg04,-1*NVL(SUM(ccg32),0) amt2 FROM ccg_file,sfb_file ",           #在制差异转出
                       "                       WHERE ccg01=sfb01 AND sfb02!=11 AND ccg32<>0 AND ccg31=0 ",
                       "                         AND ccg02=",tm.yy," AND ccg03=",tm.mm," AND ccg06='",tm.type,"'  ",
                       "                       GROUP BY ccg04 ) ON ccc01=ccg04 ",
                       "    WHERE  ccc02=",tm.yy," AND ccc03=",tm.mm,"  AND ccc07='",tm.type,"' ",
                       "      AND ((ccc212+ccc213+ccc27)<>qty OR (ccc222+ccc223+ccc28)<>NVL(amt1,0)+NVL(amt2,0)) "
            #xh--modify--end--           
         WHEN '7'      #銷退入庫
         WHEN '8'      #入庫調整
            LET l_sql= "SELECT '',ccc01,'','',' ',0,0,0,ccc225,amt,'' ",
                       "  FROM ccc_file,(SELECT ccb01,SUM(ccb22) amt FROM ccb_file ", 
                       "                  WHERE ccb02=",tm.yy," AND ccb03=",tm.mm," AND ccb06='",tm.type,"' ",
                       "                  GROUP BY ccb01) BB ",
                       " WHERE ccc01=ccb01 AND ccc08=ccb07 AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND ccc225<>amt "

         WHEN '9'      #工單發料
            LET l_sql= "SELECT'',ccc01,'','',' ',(ccc25+ccc31),qty,'',(ccc26+ccc32),amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01,SUM(tlf907*tlf10*tlf60) qty,SUM(tlf907*tlf21) amt FROM sfb_file,tlf_file ", 
                       "                  WHERE sfb01= tlf62 ",
                       "                    AND ((tlf13 LIKE 'asfi5%') OR (tlf13 LIKE 'asft6%' AND sfb02='11')) ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM jce_file) ",
                       "                    AND (tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"') ",
                       "                  GROUP BY tlf01) BB ",
                       " WHERE ccc01=tlf01 AND ccc02=",tm.yy," AND ccc03=",tm.mm,"  AND ccc07='",tm.type,"' ",
                       "   AND (ccc25+ccc31<>qty OR ccc26+ccc32<>amt) "
             
         WHEN '10'     #雜項發料
            LET l_sql= "SELECT '',ccc01,'','',' ',ccc41,qty,'',ccc42,amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01,SUM(tlf10*tlf60*tlf907) qty,SUM(tlf21*tlf907) amt  FROM tlf_file  ",
                       "                  WHERE tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "      AND tlf13 IN('aimt301','aimt311','aimt303','aimt313','aimt309') AND tlf902 NOT IN(SELECT jce02 FROM  jce_file) ",
                       "    GROUP BY tlf01) bb ",
                       " WHERE ccc01=tlf01 AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "    AND (ccc41<>qty  or ccc42<>amt) "

         WHEN '11'     #盤盈虧
            LET l_sql= "SELECT '',ccc01,'','',' ',ccc71,qty,'',ccc72,amt,'' ",
                       "  FROM ccc_file,(SELECT pia02,SUM(pia30-pia08) qty,SUM((pia30-pia08)*ccc23) amt ",
                       "                   FROM pia_file,ccc_file,tlf_file ",
                       "                  WHERE pia02=ccc01 AND pia01=tlf905 AND pia19='Y' AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                    AND pia03 NOT IN (SELECT jce02 FROM  jce_file) AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "                  GROUP BY pia02) ",
                       " WHERE ccc01=pia02 AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND (ccc71<>qty OR ccc72<>amt)"

         WHEN '12'     #銷貨成本
            LET l_sql= "SELECT '',ccc01,'','',' ',ccc61,qty,'',ccc62,amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01, SUM(tlf907*tlf10*tlf60) qty,SUM(tlf907*tlf21) amt FROM tlf_file  ",
                       "                  WHERE (tlf13 LIKE 'axmt%' OR tlf13 LIKE 'aomt%') ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file) ",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                  GROUP BY tlf01) BB  ",
                       " WHERE ccc01=tlf01 AND ccc02 = ",tm.yy," AND ccc03 = ",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND (ccc61<>qty OR ccc62<>amt) "

         WHEN '13'     #樣品出貨
            LET l_sql= "SELECT '',ccc01,'','',' ',ccc81,qty,'',ccc82,amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01, SUM(tlf907*tlf10*tlf60) qty,SUM(tlf907*tlf21) amt ",
                       "                   FROM ima_file,tlf_file,LEFT OUTER JOIN azf_file  ON tlf14=azf01 AND azf02='2' ",
                       "                  WHERE ima01 = tlf01 ",
                       "                    AND (tlf13 like 'axmt%' OR tlf13 LIKE 'aomt%') ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file) ",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                    AND azf08='N' ",
                       "                  GROUP BY tlf01) BB  ",
                       " WHERE ccc01=tlf01 AND ccc02 = ",tm.yy," AND ccc03 = ",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND (ccc81<>qty OR ccc82<>amt) "
           
         WHEN '14'     #結存調整
         WHEN '15'     #期末庫存
            LET l_sql= "SELECT '',ccc01,'','',' ',ccc91,(ccc11+ccc21+ccc25+ccc27+ccc31+ccc41+ccc51+ccc61+ccc71),'',  ",
                       "                    ccc92,(ccc12+ccc22+ccc26+ccc28+ccc32+ccc42+ccc52+ccc62+ccc72+ccc93),'' ",
                       "  FROM ccc_file ",
                       " WHERE ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND (ccc91<>(ccc11+ccc21+ccc25+ccc27+ccc31+ccc41+ccc51+ccc61+ccc71) OR ccc92<>(ccc12+ccc22+ccc26+ccc28+ccc32+ccc42+ccc52+ccc62+ccc72+ccc93)) "
         #在制
         WHEN '17'     #在制開賬調整
         WHEN '18'     #期初在制
            #xh--modify--str--
            #LET l_sql= "SELECT A.cch01,A.cch04,'','',' ',cch11,NVL(qty,0),'',cch12,NVL(amt,0),'' ",
            #           "  FROM cch_file A,(SELECT cch01,cch04,cch91 qty,cch92 amt FROM cch_file ",
            #           "                    WHERE cch02=",l_pre_yy," AND cch03=",l_pre_mm," AND cch06='",tm.type,"') B  ",
            #           " WHERE A.cch01=B.cch01(+) AND A.cch04=B.cch04  ",
            #           "   AND cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
            #           "   AND (cch11<>NVL(qty,0) OR cch12<>NVL(amt,0)) "
            LET l_sql= "SELECT A.cch01,A.cch04,'','',' ',cch11,NVL(qty,0),'',cch12,NVL(amt,0),'' ",
                       "  FROM cch_file A LEFT OUTER JOIN (SELECT cch01,cch04,cch91 qty,cch92 amt FROM cch_file ",
                       "                    WHERE cch02=",l_pre_yy," AND cch03=",l_pre_mm," AND cch06='",tm.type,"') B ON A.cch01=B.cch01 ",
                       " WHERE A.cch04=B.cch04 AND cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "   AND (cch11<>NVL(qty,0) OR cch12<>NVL(amt,0)) "
            #xh--modify--end--

         WHEN '19'     #在制投入-(原料+半成品)
            LET l_sql= "SELECT cch01,cch04,'','',' ',cch21,qty,'',cch22,amt,'' ",
                       "  FROM cch_file,(SELECT tlf01,tlf62,-1*SUM(tlf907*tlf10*tlf60) qty,-1*SUM(tlf907*tlf21) amt FROM sfb_file,tlf_file  ",
                       "                  WHERE sfb01= tlf62 ",
                       "                    AND ((tlf13 LIKE 'asfi5%') OR (tlf13 LIKE 'asft6%' AND sfb02='11')) ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file) ",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                  GROUP BY tlf01,tlf62) BB ",
                       " WHERE cch04=tlf01 AND cch01=tlf62 AND cch02 = ",tm.yy," AND cch03 = ",tm.mm," AND cch06='",tm.type,"' AND cch04 NOT IN(' DL+OH+SUB',' ADJUST') ",
                       "   AND (cch21<>qty OR cch22<>amt)"
       
         WHEN '20'     #在制投入-材料金额
            LET l_sql= "SELECT cch01,cch04,'','',' ',0,0,0,cch22a,amt,'' ",
                       "  FROM cch_file,(SELECT tlf01,tlf62,-1*SUM(tlf907*tlf221) amt FROM sfb_file,tlf_file  ",
                       "                  WHERE sfb01= tlf62 ",
                       "                    AND ((tlf13 LIKE 'asfi5%') OR (tlf13 LIKE 'asft6%' AND sfb02='11')) ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file)",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                  GROUP BY tlf01,tlf62) BB ",
                       "  WHERE cch04=tlf01 AND cch01=tlf62 AND cch02 = ",tm.yy," AND cch03 = ",tm.mm," AND cch06='",tm.type,"'  AND cch04 NOT IN(' DL+OH+SUB',' ADJUST')",
                       "    AND cch22a<>amt "

         WHEN '21'     #在制投入-直接人工
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22b),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='1' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22b)<>amt "
           #FUN-D90055--add--str--
            LET l_sql= "SELECT a.cch01,'','','',' ',0,0,0,a.cch22b,b.cdc05,'' FROM ",
                       " (SELECT cch01,SUM(cch22b) cch22b FROM cch_file ",
                       "   WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "     AND cch04=' DL+OH+SUB' ",
                       "   GROUP BY cch01) a ,",
                       " (SELECT cdc041,SUM(cdc05) cdc05 FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '1' ",
                       "   GROUP BY cdc041) b ",
                       " WHERE a.cch01=b.cdc041 AND a.cch22b<>b.cdc05 ",
                       " UNION ",
                       " SELECT cch01,'','','',' ',0,0,0,SUM(cch22b),0,'' FROM cch_file ",
                       "  WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "    AND cch04=' DL+OH+SUB' ",
                       "    AND cch22b <> 0 ",
                       "    AND NOT EXISTS(SELECT 1 FROM cdc_file WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," ",
                                          "   AND cdc11= '",tm.type,"' AND cdc04 = '1' AND cdc041=cch01) ",
                       "   GROUP BY cch01 ",
                       " UNION ",
                       " SELECT cdc041,'','','',' ',0,0,0,0,SUM(cdc05),'' FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '1' ",
                       "     AND cdc05 <> 0 ",
                       "     AND NOT EXISTS(SELECT 1 FROM cch_file WHERE cch02=",tm.yy," AND cch03=",tm.mm," ",
                                           " AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' AND cch01=cdc041 )",
                       "   GROUP BY cdc041 " 
           #FUN-D90055--add--end--

             
         WHEN '22'     #在制投入-制費1
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22c),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='2' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22c)<>amt "
           #FUN-D90055--add--str--
            LET l_sql= "SELECT a.cch01,'','','',' ',0,0,0,a.cch22c,b.cdc05,'' FROM ",
                       " (SELECT cch01,SUM(cch22c) cch22c FROM cch_file ",
                       "   WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "     AND cch04=' DL+OH+SUB' ",
                       "   GROUP BY cch01) a ,",
                       " (SELECT cdc041,SUM(cdc05) cdc05 FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '2' ",
                       "   GROUP BY cdc041) b ",
                       " WHERE a.cch01=b.cdc041 AND a.cch22c<>b.cdc05 ",
                       " UNION ", 
                       " SELECT cch01,'','','',' ',0,0,0,SUM(cch22c),0,'' FROM cch_file ",
                       "  WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "    AND cch04=' DL+OH+SUB' ",
                       "    AND cch22c <> 0 ",
                       "    AND NOT EXISTS(SELECT 1 FROM cdc_file WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," ",
                                          "   AND cdc11= '",tm.type,"' AND cdc04 = '2' AND cdc041=cch01) ",
                       "   GROUP BY cch01 ",
                       " UNION ",
                       " SELECT cdc041,'','','',' ',0,0,0,0,SUM(cdc05),'' FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '2' ",
                       "     AND cdc05 <> 0  ",
                       "     AND NOT EXISTS(SELECT 1 FROM cch_file WHERE cch02=",tm.yy," AND cch03=",tm.mm," ",
                                           " AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' AND cch01=cdc041 )",
                       "   GROUP BY cdc041 "
           #FUN-D90055--add--end--

         WHEN '23'     #在制投入-制費2
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22e),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='3' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22e)<>amt "

           #FUN-D90055--add--add--str--
            LET l_sql= "SELECT a.cch01,'','','',' ',0,0,0,a.cch22e,b.cdc05,'' FROM ",
                       " (SELECT cch01,SUM(cch22e) cch22e FROM cch_file ",
                       "   WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "     AND cch04=' DL+OH+SUB' ",
                       "   GROUP BY cch01) a ,",
                       " (SELECT cdc041,SUM(cdc05) cdc05 FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '3' ",
                       "   GROUP BY cdc041) b ",
                       " WHERE a.cch01=b.cdc041 AND a.cch22e<>b.cdc05 ",
                       " UNION ",
                       " SELECT cch01,'','','',' ',0,0,0,SUM(cch22e),0,'' FROM cch_file ",
                       "  WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "    AND cch04=' DL+OH+SUB' ",
                       "    AND cch22e <> 0 ",
                       "    AND NOT EXISTS(SELECT 1 FROM cdc_file WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," ",
                                          "   AND cdc11= '",tm.type,"' AND cdc04 = '3' AND cdc041=cch01) ",
                       "   GROUP BY cch01 ",
                       " UNION ",
                       " SELECT cdc041,'','','',' ',0,0,0,0,SUM(cdc05),'' FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '3' ",
                       "     AND cdc05 <> 0  ",
                       "     AND NOT EXISTS(SELECT 1 FROM cch_file WHERE cch02=",tm.yy," AND cch03=",tm.mm," ",
                                           " AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' AND cch01=cdc041 )",
                       "   GROUP BY cdc041 "
           #FUN-D90055--add--end--

         WHEN '24'     #在制投入-制費3
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22f),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='4' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22f)<>amt "
           #FUN-D90055--add--str--
            LET l_sql= "SELECT a.cch01,'','','',' ',0,0,0,a.cch22f,b.cdc05,'' FROM ",
                       " (SELECT cch01,SUM(cch22f) cch22f FROM cch_file ",
                       "   WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "     AND cch04=' DL+OH+SUB' ",
                       "   GROUP BY cch01) a ,",
                       " (SELECT cdc041,SUM(cdc05) cdc05 FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '4' ",
                       "   GROUP BY cdc041) b ",
                       " WHERE a.cch01=b.cdc041 AND a.cch22f<>b.cdc05 ",
                       " UNION ",
                       " SELECT cch01,'','','',' ',0,0,0,SUM(cch22f),0,'' FROM cch_file ",
                       "  WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "    AND cch04=' DL+OH+SUB' ",
                       "    AND cch22f <> 0 ",
                       "    AND NOT EXISTS(SELECT 1 FROM cdc_file WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," ",
                                          "   AND cdc11= '",tm.type,"' AND cdc04 = '4' AND cdc041=cch01) ",
                       "   GROUP BY cch01 ",
                       " UNION ",
                       " SELECT cdc041,'','','',' ',0,0,0,0,SUM(cdc05),'' FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '4' ",
                       "     AND cdc05 <> 0 ",
                       "     AND NOT EXISTS(SELECT 1 FROM cch_file WHERE cch02=",tm.yy," AND cch03=",tm.mm," ",
                                           " AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' AND cch01=cdc041 )",
                       "   GROUP BY cdc041 "
           #FUN-D90055--add--end--

         WHEN '25'     #在制投入-制費4
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22g),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='5' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22g)<>amt "
           #FUN-D90055--add--str--
            LET l_sql= "SELECT a.cch01,'','','',' ',0,0,0,a.cch22g,b.cdc05,'' FROM ",
                       " (SELECT cch01,SUM(cch22g) cch22g FROM cch_file ",
                       "   WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "     AND cch04=' DL+OH+SUB' ",
                       "   GROUP BY cch01) a ,",
                       " (SELECT cdc041,SUM(cdc05) cdc05 FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '5' ",
                       "   GROUP BY cdc041) b ",
                       " WHERE a.cch01=b.cdc041 AND a.cch22g<>b.cdc05 ",
                       " UNION ",
                       " SELECT cch01,'','','',' ',0,0,0,SUM(cch22g),0,'' FROM cch_file ",
                       "  WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "    AND cch04=' DL+OH+SUB' ",
                       "    AND cch22g <> 0 ",
                       "    AND NOT EXISTS(SELECT 1 FROM cdc_file WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," ",
                                          "   AND cdc11= '",tm.type,"' AND cdc04 = '5' AND cdc041=cch01) ",
                       "   GROUP BY cch01 ",
                       " UNION ",
                       " SELECT cdc041,'','','',' ',0,0,0,0,SUM(cdc05),'' FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '5' ",
                       "     AND cdc05 <> 0 ",
                       "     AND NOT EXISTS(SELECT 1 FROM cch_file WHERE cch02=",tm.yy," AND cch03=",tm.mm," ",
                                           " AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' AND cch01=cdc041 )",
                       "   GROUP BY cdc041 "
           #FUN-D90055--add--end--

         WHEN '26'     #在制投入-制費5
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22h),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='6' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22h)<>amt "
           #FUN-D90055--add--str--
            LET l_sql= "SELECT a.cch01,'','','',' ',0,0,0,a.cch22h,b.cdc05,'' FROM ",
                       " (SELECT cch01,SUM(cch22h) cch22h FROM cch_file ",
                       "   WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "     AND cch04=' DL+OH+SUB' ",
                       "   GROUP BY cch01) a ,",
                       " (SELECT cdc041,SUM(cdc05) cdc05 FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '6' ",
                       "   GROUP BY cdc041) b ",
                       " WHERE a.cch01=b.cdc041 AND a.cch22h<>b.cdc05 ",
                       " UNION ",
                       " SELECT cch01,'','','',' ',0,0,0,SUM(cch22h),0,'' FROM cch_file ",
                       "  WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "    AND cch04=' DL+OH+SUB' ",
                       "    AND cch22h <> 0 ",
                       "    AND NOT EXISTS(SELECT 1 FROM cdc_file WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," ",
                                          "   AND cdc11= '",tm.type,"' AND cdc04 = '6' AND cdc041=cch01) ",
                       "   GROUP BY cch01 ",
                       " UNION ",
                       " SELECT cdc041,'','','',' ',0,0,0,0,SUM(cdc05),'' FROM cdc_file ",
                       "   WHERE cdc01=",tm.yy," AND cdc02=",tm.mm," AND cdc11= '",tm.type,"' AND cdc04 = '6' ",
                       "     AND cdc05 <> 0 ",
                       "     AND NOT EXISTS(SELECT 1 FROM cch_file WHERE cch02=",tm.yy," AND cch03=",tm.mm," ",
                                           " AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' AND cch01=cdc041 )",
                       "   GROUP BY cdc041 "
           #FUN-D90055--add--end--

         WHEN '27'     #在制投入-加工費
            LET l_sql= "SELECT cch01,'','','',' ',0,0,0,SUM(cch22d),amt,'' ",
                       "  FROM cch_file,(SELECT rvv18,NVL(SUM(ckl06),0) amt FROM ckl_file,rvu_file,rvv_file ",
                       "                  WHERE rvu01=rvv01 AND ckl02=rvv01 AND ckl03=rvv02 AND rvu08='SUB'  ",
                       "                    AND ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01 IN('399_2','399_3')  ",
                       "                 GROUP BY rvv18) ",
                       " WHERE cch01=rvv18 AND cch02 = ",tm.yy," AND cch03 = ",tm.mm," AND cch06='",tm.type,"' ",
                       "   AND cch04 LIKE ' DL+OH%' " ,
                       " GROUP BY cch01,amt "
                 #      "HAVING SUM(cch22d)<>amt  "

         WHEN '28'     #在制調整
            LET l_sql= "SELECT cch01,'','','',' ',cch21,qty,'',cch22,amt,'' ",
                       "  FROM cch_file,(SELECT ccl01,ccl21 qty,ccl22 amt  FROM ccl_file ",
                       "                  WHERE ccl02=",tm.yy," AND ccl03=",tm.mm," AND ccl06='",tm.type,"') ",
                       " WHERE cch01=ccl01 AND cch02=",tm.yy," AND cch03=",tm.mm," ",
                       "   AND cch06='",tm.type,"' AND cch07=ccl07 AND cch04=' ADJUST'  ",
                       "   AND (cch21<>qty OR cch22<>amt) "

         WHEN '29'     #在制轉出
            LET l_sql= "SELECT cch01,'','','',' ',0,0,0,SUM(cch32),amt,'' ",
                       "  FROM cch_file,(SELECT tlf62,-1*SUM(tlf907*tlf21) amt FROM sfb_file,tlf_file ", 
                       "                  WHERE sfb01= tlf62 ",
                       "                    AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231' OR tlf13='asft660') ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file) ",
                       "                    AND sfb02<>'11'  ",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"'  ",
                       "                  GROUP BY tlf62) ",
                       " WHERE cch01=tlf62 AND cch02 = ",tm.yy," AND cch03 = ",tm.mm," AND cch06='",tm.type,"' ",
                       " GROUP BY cch01,amt ",
                       " HAVING SUM(cch32)<>amt  "

         WHEN '30'     #差異轉出
         WHEN '31'     #拆件差異
         WHEN '32'     #期末在制
           #MOD-D90047 modify begin-----------------------------------
           #LET l_sql= "SELECT ccg01,ccg04,'','',' ',ccg91,(ccg11+ccg21+ccg31+ccg41),'',ccg92,(ccg12+ccg22+ccg23+ccg32+ccg42),'' ",
           #           "  FROM ccg_file ",
           #           " WHERE ccg02=",tm.yy," AND ccg03=",tm.mm," AND ccg06='",tm.type,"' ",
           #           "   AND (ccg91<>(ccg11+ccg21+ccg31+ccg41) OR ccg92<>(ccg12+ccg22+ccg23+ccg32+ccg42)) "
            LET l_sql= "SELECT cch01,cch04,'','',' ',cch91,(cch11+cch21+cch31+cch41),'',cch92,(cch12+cch22+cch32+cch42),'' ",
                       "  FROM cch_file ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "   AND (cch91<>(cch11+cch21+cch31+cch41) OR cch92<>(cch12+cch22+cch32+cch42)) "
           #MOD-D90047 modify end-------------------------------------
         #其他
         WHEN '34'     #銷貨收入明細表
             #xh--modify--str--  #test ok
             #LET l_sql= "SELECT A.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",
             #           "  FROM ckl_file A,(SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
             #           "                    WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='317' GROUP BY ckl02) B ",        
             #           " WHERE A.ckl02=B.ckl02(+) ",
             #           "   AND A.ckl07=",tm.yy," AND A.ckl08=",tm.mm,"  ",
             #           "   AND A.ckl01='312' ",
             #           " GROUP BY A.ckl02,qty,amt ",
             #           "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  "
             LET l_sql= "SELECT A.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",
                        "  FROM ckl_file A LEFT OUTER JOIN (SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
                        "                    WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='317' GROUP BY ckl02) B ON A.ckl02=B.ckl02 ",        
                        " WHERE A.ckl07=",tm.yy," AND A.ckl08=",tm.mm,"  ",
                        "   AND A.ckl01='312' ",
                        " GROUP BY A.ckl02,qty,amt ",
                        "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  "
             #xh--modify--end--
                       
         WHEN '35'     #採購入庫金額
             #fr--modify--str-- #test ok
             #LET l_sql= "SELECT A.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",
             #           "  FROM ckl_file A,(SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
             #           "                    WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='318' GROUP BY ckl02) B ",        
             #           " WHERE A.ckl02=B.ckl02(+) ",
             #           "   AND A.ckl07=",tm.yy," AND A.ckl08=",tm.mm,"  ",
             #           "   AND A.ckl01 LIKE '399%' ",
             #           " GROUP BY A.ckl02,qty,amt ",
             #           "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  ",
             #           "UNION ",
             #           "SELECT B.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",    #费用采购有立帐无tlf的情况
             #           "  FROM ckl_file A,(SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
             #           "                    WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='318' GROUP BY ckl02) B ",        
             #           " WHERE B.ckl02=A.ckl02(+) ",
             #           "   AND A.ckl07(+)=",tm.yy," AND A.ckl08(+)=",tm.mm,"  ",
             #           "   AND A.ckl01(+) LIKE '399%' ",
             #           " GROUP BY B.ckl02,qty,amt ",
             #           "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  "
             LET l_sql= "SELECT A.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",
                        "  FROM ckl_file A ",
                        "  LEFT OUTER JOIN (SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
                        "                    WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='318' GROUP BY ckl02) B ON A.ckl02=B.ckl02",        
                        " WHERE A.ckl07=",tm.yy," AND A.ckl08=",tm.mm,"  ",
                        "   AND A.ckl01 LIKE '399%' ",
                        " GROUP BY A.ckl02,qty,amt ",
                        "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  ",
                        "UNION ",
                        "SELECT B.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",    #费用采购有立帐无tlf的情况
                        "  FROM (SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
                        "         WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='318' GROUP BY ckl02) B ",   
                        "          LEFT OUTER JOIN ckl_file A ON B.ckl02=A.ckl02 AND A.ckl07=",tm.yy," ",
                        "                                    AND A.ckl08=",tm.mm," AND A.ckl01 LIKE '399%' ",
                        " GROUP BY B.ckl02,qty,amt ",
                        "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  "
             #fr--modify--str--

         OTHERWISE EXIT CASE 
           
      END CASE
   END IF 
   IF g_ccz.ccz28 MATCHES '[3,4,5]' THEN 
      CASE l_cki01 
         WHEN '2'      #庫存開賬調整
         WHEN '3'      #期初庫存
            #fr--modify--str--
            #LET l_sql= "SELECT '',ccc01,'','',ccc08,ccc11,NVL(qty,0),'',ccc12,NVL(amt,0),'' ",
            #           "  FROM ccc_file,(SELECT ccc01,ccc08,ccc91 qty,ccc92 amt FROM ccc_file  ",
            #           "                  WHERE ccc02=",l_pre_yy," AND ccc03=",l_pre_mm,") bb  ",
            #           " WHERE ccc01=bb.ccc01(+) AND ccc07=bb.ccc07 AND ccc08=bb.ccc08  ",
            #           "   AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"'  ",
            #           "   AND (ccc11<>NVL(qty,0) OR ccc12<>NVL(amt,0))  "
            LET l_sql= "SELECT '',ccc01,'','',ccc08,ccc11,NVL(qty,0),'',ccc12,NVL(amt,0),'' ",
                       "  FROM ccc_file aa ",
                       "  LEFT OUTER JOIN (SELECT ccc01,ccc07,ccc08,ccc91 qty,ccc92 amt FROM ccc_file  ",
                       "                    WHERE ccc02=",l_pre_yy," AND ccc03=",l_pre_mm,") bb ON  aa.ccc01=bb.ccc01 ",
                       " WHERE aa.ccc07=bb.ccc07 AND aa.ccc08=bb.ccc08  ",
                       "   AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND aa.ccc07='",tm.type,"'  ",
                       "   AND (ccc11<>NVL(qty,0) OR ccc12<>NVL(amt,0))  "
            #fr--modify--end--

         WHEN '4'      #一般採購
            LET l_sql= "SELECT '',ccc01,'','',ccc08,ccc211,qty,'',ccc221,amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01,tlfcost,SUM(tlf10*tlf60*tlf907) qty,SUM(tlf21*tlf907) amt FROM tlf_file ",
                       "                  WHERE tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                    AND (tlf13 = 'apmt150' OR tlf13 = 'apmt1072' OR tlf13 = 'apmt230') ",
                       "                    AND tlf902 NOT IN(SELECT jce02 FROM jce_file)  ",
                       "                  GROUP BY tlf01,tlfcost) bb       ",
                       " WHERE ccc01=tlf01 AND ccc08=tlfcost AND ccc02=",tm.yy,"  AND ccc03=",tm.mm," AND ccc07='",tm.type,"'  ",
                       "   AND (ccc211<>qty OR ccc221<>amt) "

         WHEN '5'      #雜項入庫
            LET l_sql= "SELECT '',ccc01,'','',ccc08,ccc214,qty,'',ccc224,amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01,tlfcost,SUM(tlf10*tlf60*tlf907) qty,SUM(tlf21*tlf907) amt  FROM tlf_file  ",
                       "                  WHERE tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                    AND tlf13 IN('aimt302','aimt312','aimt306') AND tlf902 NOT IN(SELECT jce02 FROM jce_file) ",
                       "                  GROUP BY tlf01,tlfcost) bb   ",
                       " WHERE ccc01=tlf01 AND ccc08=tlfcost AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND (ccc214<>qty OR ccc224<>amt) "

         WHEN '6'      #工單入庫
            LET l_sql= "SELECT '',ccc01,'','',ccc08,(ccc212+ccc213+ccc27),qty,'',(ccc222+ccc223+ccc28),amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01,tlfcost,SUM(tlf10*tlf60*tlf907) qty,SUM(tlf907*tlf21) amt FROM sfb_file,tlf_file  ",
                       "                  WHERE sfb01= tlf62 ",
                       "                    AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231' OR tlf13='asft660') ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file)  ",
                       "                    AND (tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ) ",
                       "                  GROUP BY tlf01,tlfcost ) BB ",
                       " WHERE ccc01=tlf01 AND ccc08=tlfcost AND ccc02=",tm.yy," AND ccc03=",tm.mm,"  AND ccc07='",tm.type,"' ",
                       "   AND ((ccc212+ccc213+ccc27)<>qty OR (ccc222+ccc223+ccc28)<>amt)"

         WHEN '7'      #銷退入庫
         WHEN '8'      #入庫調整
            LET l_sql= "SELECT '',ccc01,'','',ccc08,0,0,0,ccc225,amt,'' ",
                       "  FROM ccc_file,(SELECT ccb01,ccb07,SUM(ccb22) amt FROM ccb_file ", 
                       "                  WHERE ccb02=",tm.yy," AND ccb03=",tm.mm," AND ccb06='",tm.type,"' ",
                       "                  GROUP BY ccb01,ccb07) BB ",
                       " WHERE ccc01=ccb01 AND ccc08=ccb07 AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND ccc225<>amt "

         WHEN '9'      #工單發料
            LET l_sql= "SELECT'',ccc01,'','',ccc08,(ccc25+ccc31),qty,'',(ccc26+ccc32),amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01,tlfcost,SUM(tlf907*tlf10*tlf60) qty,SUM(tlf907*tlf21) amt FROM sfb_file,tlf_file ", 
                       "                  WHERE sfb01= tlf62 ",
                       "                    AND ((tlf13 LIKE 'asfi5%') OR (tlf13 LIKE 'asft6%' AND sfb02='11')) ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM jce_file) ",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                  GROUP BY tlf01,tlfcost) BB ",
                       " WHERE ccc01=tlf01 AND ccc08=tlfcost AND ccc02=",tm.yy," AND ccc03=",tm.mm,"  AND ccc07='",tm.type,"' ",
                       "   AND (ccc25+ccc31<>qty OR ccc26+ccc32<>amt) "
             
         WHEN '10'     #雜項發料
            LET l_sql= "SELECT '',ccc01,'','',ccc08,ccc41,qty,'',ccc42,amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01,tlfcost,SUM(tlf10*tlf60*tlf907) qty,SUM(tlf21*tlf907) amt  FROM tlf_file  ",
                       "                  WHERE tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                    AND tlf13 IN('aimt301','aimt311','aimt303','aimt313','aimt309') ",
                       "                    AND tlf902 NOT IN(SELECT jce02 FROM  jce_file) ",
                       "                 GROUP BY tlf01,tlfcost) bb ",
                       " WHERE ccc01=tlf01 AND ccc08=tlfcost AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "    AND (ccc41<>qty  or ccc42<>amt) "

         WHEN '11'     #盤盈虧
            LET l_sql= "SELECT '',ccc01,'','',ccc08,ccc71,qty,'',ccc72,amt,'' ",
                       "  FROM ccc_file,(SELECT pia02,SUM(pia30-pia08) qty,SUM((pia30-pia08)*ccc23) amt ",
                       "                   FROM pia_file,ccc_file,tlf_file ",
                       "                  WHERE pia02=ccc01 AND pia01=tlf905 AND pia19='Y' AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                    AND pia03 NOT IN (SELECT jce02 FROM  jce_file) AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "                  GROUP BY pia02) ",
                       " WHERE ccc01=pia02 AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND (ccc71<>qty OR ccc72<>amt)"

         WHEN '12'     #銷貨成本
            LET l_sql= "SELECT '',ccc01,'','',ccc08,ccc61,qty,'',ccc62,amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01,tlfcost,SUM(tlf907*tlf10*tlf60) qty,SUM(tlf907*tlf21) amt FROM tlf_file  ",
                       "                  WHERE (tlf13 LIKE 'axmt%' OR tlf13 LIKE 'aomt%') ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file) ",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                  GROUP BY tlf01,tlfcost) BB  ",
                       " WHERE ccc01=tlf01 AND ccc08=tlfcost AND ccc02 = ",tm.yy," AND ccc03 = ",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND (ccc61<>qty OR ccc62<>amt) "

         WHEN '13'     #樣品出貨
            LET l_sql= "SELECT '',ccc01,'','',ccc08,ccc81,qty,'',ccc82,amt,'' ",
                       "  FROM ccc_file,(SELECT tlf01,tlfcost,SUM(tlf907*tlf10*tlf60) qty,SUM(tlf907*tlf21) amt ",
                       "                   FROM ima_file,tlf_file,LEFT OUTER JOIN azf_file  ON tlf14=azf01 AND azf02='2' ",
                       "                  WHERE ima01 = tlf01 ",
                       "                    AND (tlf13 like 'axmt%' OR tlf13 LIKE 'aomt%') ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file) ",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                    AND azf08='N' ",
                       "                  GROUP BY tlf01,tlfcost) BB  ",
                       " WHERE ccc01=tlf01 AND ccc08=tlfcost AND ccc02 = ",tm.yy," AND ccc03 = ",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND (ccc81<>qty OR ccc82<>amt) "
           
         WHEN '14'     #結存調整
         WHEN '15'     #期末庫存
            LET l_sql= "SELECT '',ccc01,'','',ccc08,ccc91,(ccc11+ccc21+ccc25+ccc27+ccc31+ccc41+ccc51+ccc61+ccc71),'', ",
                       "                    ccc92,(ccc12+ccc22+ccc26+ccc28+ccc32+ccc42+ccc52+ccc62+ccc72+ccc93),'' ",
                       "  FROM ccc_file ",
                       " WHERE ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.type,"' ",
                       "   AND (ccc91<>(ccc11+ccc21+ccc25+ccc27+ccc31+ccc41+ccc51+ccc61+ccc71) OR ccc92<>(ccc12+ccc22+ccc26+ccc28+ccc32+ccc42+ccc52+ccc62+ccc72+ccc93)) "
         #在制
         WHEN '17'     #在制開賬調整
         WHEN '18'     #期初在制
            #fr--modify--str--
            #LET l_sql= "SELECT A.cch01,A.cch04,'','',cch07,cch11,NVL(qty,0),'',cch12,NVL(amt,0),'' ",
            #           "  FROM cch_file A,(SELECT cch01,cch04,cch91 qty,cch92 amt FROM cch_file ",
            #           "                    WHERE cch02=",l_pre_yy," AND cch03=",l_pre_mm," AND cch06='",tm.type,"') B  ",
            #           " WHERE cch01=B.cch01(+) AND cch07=B.cch07 AND cch04=B.cch04 ",
            #           "   AND cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
            #           "   AND (cch11<>NVL(qty,0) OR cch12<>NVL(amt,0)) "
            LET l_sql= "SELECT A.cch01,A.cch04,'','',cch07,cch11,NVL(qty,0),'',cch12,NVL(amt,0),'' ",
                       "  FROM cch_file A ",
                       "  LEFT OUTER JOIN (SELECT cch01,cch04,cch07,cch91 qty,cch92 amt FROM cch_file ",
                       "                    WHERE cch02=",l_pre_yy," AND cch03=",l_pre_mm," AND cch06='",tm.type,"') B ON A.cch01=B.cch01 ",
                       " WHERE A.cch07=B.cch07 AND A.cch04=B.cch04 ",
                       "   AND cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "   AND (cch11<>NVL(qty,0) OR cch12<>NVL(amt,0)) "
            #fr--modify--end--

         WHEN '19'     #在制投入-(原料+半成品)
            LET l_sql= "SELECT cch01,cch04,'','',cch07,cch21,qty,'',cch22,amt,'' ",
                       "  FROM cch_file,(SELECT tlf01,tlf62,tlfcost,-1*SUM(tlf907*tlf10*tlf60) qty,-1*SUM(tlf907*tlf21) amt FROM sfb_file,tlf_file  ",
                       "                  WHERE sfb01= tlf62 ",
                       "                    AND ((tlf13 LIKE 'asfi5%') OR (tlf13 LIKE 'asft6%' AND sfb02='11')) ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file) ",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                  GROUP BY tlf01,tlf62,tlfcost ) BB ",
                       " WHERE cch04=tlf01 AND cch01=tlf62 AND cch07=tlfcost AND cch02 = ",tm.yy," AND cch03 = ",tm.mm," AND cch06='",tm.type,"' ",
                       "   AND cch04 NOT IN(' DL+OH+SUB',' ADJUST') ",
                       "   AND (cch21<>qty OR cch22<>amt)"
       
         WHEN '20'     #在制投入-材料金额
            LET l_sql= "SELECT cch01,cch04,'','',cch07,0,0,0,cch22a,amt,'' ",
                       "  FROM cch_file,(SELECT tlf01,tlf62,tlfcost,SUM(tlf907*tlf221) amt FROM sfb_file,tlf_file  ",
                       "                  WHERE  sfb01= tlf62 ",
                       "                    AND ((tlf13 LIKE 'asfi5%') OR (tlf13 LIKE 'asft6%' AND sfb02='11')) ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file)",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                  GROUP BY tlf01,tlf62,tlfcost) BB ",
                       "  WHERE cch04=tlf01 AND cch01=tlf62 AND cch07=tlfcost AND cch02 = ",tm.yy," AND cch03 = ",tm.mm," AND cch06='",tm.type,"'  ",
                       "    AND cch04 NOT IN(' DL+OH+SUB',' ADJUST')",
                       "    AND cch22a<>amt "

         WHEN '21'     #在制投入-直接人工
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22b),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='1' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22b)<>amt "
             
         WHEN '22'     #在制投入-制費1
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22c),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='2' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22c)<>amt "

         WHEN '23'     #在制投入-制費2
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22e),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='3' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22e)<>amt "

         WHEN '24'     #在制投入-制費3
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22f),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='4' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22f)<>amt "

         WHEN '25'     #在制投入-制費4
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22g),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='5' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22g)<>amt "

         WHEN '26'     #在制投入-制費5
            LET l_sql= "SELECT '','','','',' ',0,0,0,SUM(cch22h),amt,'' ",
                       "  FROM cch_file,(SELECT NVL(SUM(cmi08),0) amt FROM cmi_file ",
                       "                  WHERE cmi04='6' AND cmi01=",tm.yy," AND cmi02=",tm.mm," AND cmi00='",g_aaz.aaz64,"') ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' AND cch04=' DL+OH+SUB' ",
                       " GROUP BY amt ",
                       " HAVING SUM(cch22h)<>amt "

         WHEN '27'     #在制投入-加工費
            LET l_sql= "SELECT cch01,cch04,'','',cch07,0,0,0,cch22d,amt,'' ",
                       "  FROM cch_file,(SELECT tlf01,tlf62,tlfcost,SUM(tlf907*tlf21) amt FROM sfb_file,tlf_file  ",
                       "                  WHERE  sfb01= tlf62 ",
                       "                    AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231') ",
                       "                    AND (sfb02 = 7 OR sfb02 = 8)  ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file) ",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"' ",
                       "                 GROUP BY tlf01,tlf62,tlfcost) BB ",
                       " WHERE  cch04=tlf01 AND cch01=tlf62 AND cch07=tlfcost AND cch02 = ",tm.yy," AND cch03 = ",tm.mm," AND cch06='",tm.type,"' ",
                       "   AND cch22d<>amt  "

         WHEN '28'     #在制調整
            LET l_sql= "SELECT cch01,'','','',cch07,cch21,qty,'',cch22,amt,'' ",
                       "  FROM cch_file,(SELECT ccl01,ccl07,ccl21 qty,ccl22 amt  FROM ccl_file ",
                       "                  WHERE ccl02=",tm.yy," AND ccl03=",tm.mm," AND ccl06='",tm.type,"') ",
                       " WHERE cch01=ccl01 AND cch02=",tm.yy," AND cch03=",tm.mm," ",
                       "   AND cch06='",tm.type,"' AND cch04=' ADJUST'  ",
                       "   AND (cch21<>qty OR cch22<>amt) "

         WHEN '29'     #在制轉出
            LET l_sql= "SELECT cch01,'','','',cch07,0,0,0,SUM(cch32),amt,'' ",
                       "  FROM cch_file,(SELECT tlf62,tlfcost,-1*SUM(tlf907*tlf21) amt FROM sfb_file,tlf_file ", 
                       "                  WHERE sfb01= tlf62 ",
                       "                    AND (tlf13 = 'asft6201' OR tlf13 = 'asft6101' OR tlf13 = 'asft6231' OR tlf13='asft660') ",
                       "                    AND tlf902 NOT IN (SELECT jce02 FROM  jce_file) ",
                       "                    AND sfb02<>'11'  ",
                       "                    AND tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"'  ",
                       "                  GROUP BY tlf62,tlfcost) ",
                       " WHERE cch01=tlf62 AND cch07=tlfcost AND cch02 = ",tm.yy," AND cch03 = ",tm.mm," AND cch06='",tm.type,"' ",
                       " GROUP BY cch01,amt ",
                       " HAVING SUM(cch32)<>amt  "

         WHEN '30'     #差異轉出
         WHEN '31'     #拆件差異
         WHEN '32'     #期末在制
           #LET l_sql= "SELECT ccg01,ccg04,'','',ccg07,ccg91,(ccg11+ccg21+ccg31+ccg41),'',ccg92,(ccg12+ccg22+ccg23+ccg32+ccg42),'' ",
           #           "  FROM ccg_file ",
           #           " WHERE ccg02=",tm.yy," AND ccg03=",tm.mm," AND ccg06='",tm.type,"' ",
           #           "   AND (ccg91<>(ccg11+ccg21+ccg31+ccg41) OR ccg92<>(ccg12+ccg22+ccg23+ccg32+ccg42)) "
            LET l_sql= "SELECT cch01,cch04,'','',cch07,cch91,(cch11+cch21+cch31+cch41),'',cch92,(cch12+cch22+cch32+cch42),'' ",
                       "  FROM cch_file ",
                       " WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND cch06='",tm.type,"' ",
                       "   AND (cch91<>(cch11+cch21+cch31+cch41) OR cch92<>(cch12+cch22+cch32+cch42)) "

         #其他
         WHEN '34'     #銷貨收入明細表
             #fr--modify--str--
             #LET l_sql= "SELECT A.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",
             #           "  FROM ckl_file A,(SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
             #           "                    WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='317' GROUP BY ckl02) B ",        
             #           " WHERE A.ckl02=B.ckl02(+) ",
             #           "   AND A.ckl07=",tm.yy," AND A.ckl08=",tm.mm,"  ",
             #           "   AND A.ckl01='312' ",
             #           " GROUP BY A.ckl02,qty,amt ",
             #           "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  "
             LET l_sql= "SELECT A.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",
                        "  FROM ckl_file A ",
                        "  LEFT OUTER JOIN (SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
                        "                    WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='317' GROUP BY ckl02) B ON A.ckl02=B.ckl02 ",        
                        " WHERE A.ckl07=",tm.yy," AND A.ckl08=",tm.mm,"  ",
                        "   AND A.ckl01='312' ",
                        " GROUP BY A.ckl02,qty,amt ",
                        "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  "
             #fr--modify--end--

         WHEN '35'     #採購入庫金額
             #fr--modify--str--
             #LET l_sql= "SELECT A.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",
             #           "  FROM ckl_file A,(SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
             #           "                    WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='318' GROUP BY ckl02) B ",        
             #           " WHERE A.ckl02=B.ckl02(+) ",
             #           "   AND A.ckl07=",tm.yy," AND A.ckl08=",tm.mm,"  ",
             #           "   AND A.ckl01 LIKE '399%' ",
             #           " GROUP BY A.ckl02,qty,amt ",
             #           "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  ",
             #           "UNION ",
             #           "SELECT B.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",
             #           "  FROM ckl_file A,(SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
             #           "                    WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='318' GROUP BY ckl02) B ",        
             #           " WHERE B.ckl02=A.ckl02(+) ",
             #           "   AND A.ckl07(+)=",tm.yy," AND A.ckl08(+)=",tm.mm,"  ",
             #           "   AND A.ckl01(+) LIKE '399%' ",
             #           " GROUP BY B.ckl02,qty,amt ",
             #           "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  "
             LET l_sql= "SELECT A.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",
                        "  FROM ckl_file A ",
                        "  LEFT OUTER JOIN (SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
                        "                    WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='318' GROUP BY ckl02) B ON A.ckl02=B.ckl02 ",        
                        " WHERE A.ckl07=",tm.yy," AND A.ckl08=",tm.mm,"  ",
                        "   AND A.ckl01 LIKE '399%' ",
                        " GROUP BY A.ckl02,qty,amt ",
                        "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  ",
                        "UNION ",
                        "SELECT B.ckl02,'','','',' ',NVL(qty,0),NVL(SUM(A.ckl05),0),'',NVL(amt,0),NVL(SUM(A.ckl06),0),'' ",
                        "  FROM (SELECT ckl02,SUM(ckl05) qty,SUM(ckl06) amt FROM ckl_file ",
                        "         WHERE ckl07=",tm.yy," AND ckl08=",tm.mm," AND ckl01='318' GROUP BY ckl02) B ",
                        "  LEFT OUTER JOIN ckl_file A ON B.ckl02=A.ckl02 AND A.ckl07=",tm.yy," ",
                        "   AND A.ckl08=",tm.mm," AND A.ckl01 LIKE '399%' ",
                        " GROUP BY B.ckl02,qty,amt ",
                        "HAVING (NVL(SUM(A.ckl05),0)<> NVL(qty,0) OR NVL(amt,0)<>NVL(SUM(A.ckl06),0))  "
             #fr--modify--end--
         OTHERWISE EXIT CASE 
      END CASE
   END IF 
   LET g_cnt2 = 1
   LET sr.sumqty1=0
   LET sr.sumqty2=0
   LET sr.sumqty3=0
   LET sr.sumtot1=0
   LET sr.sumtot2=0
   LET sr.sumtot3=0
   CALL g_ccc.clear()
   IF NOT cl_null(l_sql) THEN 
      PREPARE q100_pre05 FROM l_sql
      DECLARE q100_cs05 CURSOR FOR q100_pre05
      FOREACH q100_cs05 INTO g_ccc[g_cnt2].*
         IF cl_null(g_ccc[g_cnt2].qty1) THEN LET g_ccc[g_cnt2].qty1=0 END IF
         IF cl_null(g_ccc[g_cnt2].qty2) THEN LET g_ccc[g_cnt2].qty2=0 END IF
         IF cl_null(g_ccc[g_cnt2].tot1) THEN LET g_ccc[g_cnt2].tot1=0 END IF
         IF cl_null(g_ccc[g_cnt2].tot2) THEN LET g_ccc[g_cnt2].tot2=0 END IF
         LET g_ccc[g_cnt2].qty3 = g_ccc[g_cnt2].qty1-g_ccc[g_cnt2].qty2
         LET g_ccc[g_cnt2].tot3 = g_ccc[g_cnt2].tot1-g_ccc[g_cnt2].tot2

         SELECT ima02,ima021 INTO g_ccc[g_cnt2].ima02,g_ccc[g_cnt2].ima021 FROM ima_file  
          WHERE ima01 = g_ccc[g_cnt2].ccc01 AND imaacti='Y'
         IF NOT cl_null(g_ccc[g_cnt2].qty1) THEN 
            LET sr.sumqty1=sr.sumqty1+g_ccc[g_cnt2].qty1
         END IF 
         IF NOT cl_null(g_ccc[g_cnt2].qty2) THEN 
            LET sr.sumqty2=sr.sumqty2+g_ccc[g_cnt2].qty2
         END IF 
         IF NOT cl_null(g_ccc[g_cnt2].qty3) THEN 
            LET sr.sumqty3=sr.sumqty3+g_ccc[g_cnt2].qty3
         END IF 
         IF NOT cl_null(g_ccc[g_cnt2].tot1) THEN 
            LET sr.sumtot1=sr.sumtot1+g_ccc[g_cnt2].tot1
         END IF 
         IF NOT cl_null(g_ccc[g_cnt2].tot2) THEN 
            LET sr.sumtot2=sr.sumtot2+g_ccc[g_cnt2].tot2
         END IF 
         IF NOT cl_null(g_ccc[g_cnt2].tot3) THEN 
            LET sr.sumtot3=sr.sumtot3+g_ccc[g_cnt2].tot3
         END IF 
         LET g_cnt2 = g_cnt2 + 1
      END FOREACH 
      CALL g_ccc.deleteElement(g_cnt2)
   END IF 
   LET g_cnt2 = g_cnt2 - 1
         
END FUNCTION


FUNCTION q100_diff_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          

   LET g_action_choice = ''
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY g_cnt2 TO cn3
   DISPLAY BY NAME sr.*
   DISPLAY ARRAY g_ccc TO s_ccc.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
   END DISPLAY
   #CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-C80092
