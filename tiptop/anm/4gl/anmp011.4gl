# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: anmp011.4gl
# Descriptions...: 網銀整批支付作業 
# Date & Author..: No.FUN-B30213 11/04/01 By lixia 
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
    g_nme         DYNAMIC ARRAY OF RECORD
        chk       LIKE type_file.chr1,
        nme22     LIKE nme_file.nme22,
        nme13     LIKE nme_file.nme13,
        nme01     LIKE nme_file.nme01,
        nma02     LIKE nma_file.nma02,
        nma04     LIKE nma_file.nma04,
        nme02     LIKE nme_file.nme02,
        nme04     LIKE nme_file.nme04,
        nme08     LIKE nme_file.nme08,
        nme12     LIKE nme_file.nme12,
        nme24     LIKE nme_file.nme24,
        nme05     LIKE nme_file.nme05,
        nme27     LIKE nme_file.nme27
                  END RECORD,
    g_nme_t       RECORD                 #程式變數 (舊值)
        chk       LIKE type_file.chr1,
        nme22     LIKE nme_file.nme22,
        nme13     LIKE nme_file.nme13,
        nme01     LIKE nme_file.nme01,
        nma02     LIKE nma_file.nma02,
        nma04     LIKE nma_file.nma04,
        nme02     LIKE nme_file.nme02,
        nme04     LIKE nme_file.nme04,
        nme08     LIKE nme_file.nme08,
        nme12     LIKE nme_file.nme12,
        nme24     LIKE nme_file.nme24,
        nme05     LIKE nme_file.nme05,
        nme27     LIKE nme_file.nme27
                  END RECORD,   
    g_wc,g_wc2,g_sql        STRING,  
    g_rec_b                 LIKE type_file.num5,      #單身筆數
    l_ac                    LIKE type_file.num5       #目前處理的ARRAY CNT
DEFINE g_forupd_sql         STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  STRING
DEFINE g_cnt                LIKE type_file.num10   
DEFINE g_xh                 LIKE type_file.num5  
DEFINE g_noa05              LIKE noa_file.noa05 #交易類型
DEFINE g_noa02              LIKE noa_file.noa02 #版本编号 
 
MAIN 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF

   IF g_aza.aza73 = 'N' THEN
      CALL cl_err('','anm-980',1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   OPEN WINDOW p011_w WITH FORM "anm/42f/anmp011"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
   CALL p011_menu()
 
   CLOSE WINDOW p011_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time                
END MAIN
 
FUNCTION p011_menu()
 
   WHILE TRUE
      CALL p011_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p011_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_nme[1].nme01 IS NOT NULL THEN
                  CALL p011_b()
               ELSE
                  LET g_action_choice = NULL
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nme),'','')
            END IF
         WHEN "direct_pay"
            IF cl_chk_act_auth() THEN
               CALL p011_direct()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "landing_pay"
            IF cl_chk_act_auth() THEN
               CALL p011_landing()
            ELSE
               LET g_action_choice = NULL
            END IF 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION p011_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nme TO s_nme.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE                 
         LET g_action_choice="exit"
         EXIT DISPLAY
   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()  
   
      ON ACTION exporttoexcel      
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION direct_pay
         LET g_action_choice = 'direct_pay'
         EXIT DISPLAY
         
      ON ACTION landing_pay
         LET g_action_choice = 'landing_pay'
         EXIT DISPLAY  
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p011_q()
   CLEAR FORM
   CALL g_nme.clear()
 
   CONSTRUCT g_wc ON nme22,nme13,nme01,nme02,nme04,nme08,nme12,nme24,nme05,nme27
        FROM s_nme[1].nme22,s_nme[1].nme13,s_nme[1].nme01,s_nme[1].nme02,s_nme[1].nme04,
             s_nme[1].nme08,s_nme[1].nme12,s_nme[1].nme24,s_nme[1].nme05,s_nme[1].nme27
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init() 
 
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
   
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)  
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF 
   CALL p011_b_fill(g_wc) 
END FUNCTION

FUNCTION p011_b()
   DEFINE l_n    LIKE type_file.num5
   DEFINE p_cmd  LIKE type_file.chr1 
   
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF 
   CALL cl_opmsg('b') 
   
   INPUT ARRAY g_nme WITHOUT DEFAULTS FROM s_nme.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
            INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)                   
            
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         
      BEFORE ROW
         LET l_ac = ARR_CURR() 
         LET l_n  = ARR_COUNT()  
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_nme_t.* = g_nme[l_ac].*
            CALL cl_show_fld_cont()
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR() 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nme[l_ac].* = g_nme_t.*
            END IF
            EXIT INPUT
         END IF
         IF NOT cl_null(g_nme[l_ac].nme27) AND g_nme[l_ac].nme27 <> ' ' THEN 
            UPDATE nme_tmp1 SET chk = g_nme[l_ac].chk 
             WHERE nme27 = g_nme[l_ac].nme27
         END IF    
           
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
         
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help() 
   END INPUT 
 
END FUNCTION 
 
FUNCTION p011_b_fill(p_wc)   
   DEFINE  p_wc     STRING  
   DEFINE  l_sql    STRING    
 
   LET g_sql = "SELECT 'N',nme22,nme13,nme01,'','',nme02,nme04,nme08,nme12,nme24,nme05,nme27 ",  
               "  FROM nme_file,nma_file ",
               " WHERE ", p_wc CLIPPED,  
               "   AND nme24 IN ('1','9') ",      
               "   AND nma43='Y' ",
               "   AND nma01 = nme01 ",
               " ORDER BY nme01"
   PREPARE p011_pb FROM g_sql
   DECLARE nme_curs CURSOR FOR p011_pb
 
   CALL g_nme.clear() 
   LET g_cnt = 1
 
   FOREACH nme_curs INTO g_nme[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      SELECT nma02,nma04 INTO g_nme[g_cnt].nma02,g_nme[g_cnt].nma04 FROM nma_file 
       WHERE nma01 = g_nme[g_cnt].nme01   
      LET g_cnt = g_cnt + 1 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF 
   END FOREACH
 
   CALL g_nme.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt  
   LET g_cnt = 0
   IF g_rec_b > 0 THEN
      LET g_xh = 0
      DROP TABLE nme_tmp1
      CREATE TEMP TABLE nme_tmp1(
                         chk   LIKE type_file.chr1,
                         nme01 LIKE nme_file.nme01,
                         nme27 LIKE nme_file.nme27)
       LET l_sql = " INSERT INTO nme_tmp1 ",
                   " SELECT 'N',nme01,nme27 FROM nme_file,nma_file ",
                   " WHERE ", p_wc CLIPPED,  
                   "   AND nme24 IN ('1','9') ",      
                   "   AND nma43='Y' ",
                   "   AND nma01 = nme01 ",
                   " ORDER BY nme01"
       PREPARE p011_pre_y FROM l_sql
       EXECUTE p011_pre_y 
    END IF    
END FUNCTION

#直接支付
FUNCTION p011_direct()   
   DEFINE l_nma47       LIKE nma_file.nma47 #接口銀行編碼
   DEFINE l_nma01       LIKE nma_file.nma01
   DEFINE l_noa06       LIKE noa_file.noa06
   DEFINE l_noa07       LIKE noa_file.noa07
   DEFINE l_nme01       LIKE nme_file.nme01
   DEFINE l_nme27       LIKE nme_file.nme27
   DEFINE l_str12       STRING              #完整的報文XML
   DEFINE l_str13       STRING              #報文內容XML
   DEFINE l_i           LIKE type_file.num10  
   DEFINE l_success     LIKE type_file.chr1 

   LET l_i = 0
   LET g_noa05 = ''
   LET g_noa02 = ''
   LET l_nma47 = ''
   LET l_nma01 = ''
 
   SELECT COUNT(*) INTO l_i FROM nme_tmp1 WHERE chk = 'Y'
   IF l_i < 1 THEN
      CALL cl_err("","aic-044",1)
      RETURN
   END IF 
   
   IF NOT cl_sure(18,20) THEN RETURN END IF   
   #1.輸入交易類型   
   LET g_sql = " SELECT DISTINCT nma01,nma47 FROM nma_file,nme_tmp1 ",
               "  WHERE chk = 'Y' AND nme01 = nma01 ",
               "  ORDER BY nma01 "
   PREPARE p011_pre_n1 FROM g_sql
   EXECUTE p011_pre_n1 INTO l_nma01,l_nma47    
   IF cl_null(l_nma47) THEN
      CALL cl_err(l_nma01,'anm1019',1)
      RETURN 
   END IF 
   CALL p011_info(l_nma47)  RETURNING g_noa05,g_noa02
   IF cl_null(g_noa05) OR cl_null(g_noa02) THEN
      CALL cl_err("","anm1038",1)
      RETURN
   END IF

   LET l_success = 'Y'   
   CALL s_showmsg_init()
   
   DECLARE p011_nme_cs1 CURSOR WITH HOLD FOR SELECT nme01,nme27 FROM nme_tmp1 WHERE chk = 'Y'
   FOREACH p011_nme_cs1 INTO l_nme01,l_nme27      
      IF cl_null(l_nme01) THEN
         CONTINUE FOREACH
      END IF
      
      LET g_success = 'Y'      
      
      #流水號作為唯一標誌，不能為空
      IF cl_null(l_nme27) OR l_nme27 = ' ' THEN
         LET g_success = 'N'
         CALL s_errmsg('nme27',l_nme27,'','anm1026',1)
      END IF

      #根據銀行編號抓取接口銀行編碼
      SELECT nma47 INTO l_nma47 FROM nma_file WHERE nma01 = l_nme01 AND nmaacti = 'Y'
      IF cl_null(l_nma47) THEN
         LET g_success = 'N'
         CALL s_errmsg('nme01',l_nme01,'','anm1019',1)
      END IF

      #2.anmi013中抓取公共配置信息組成xml
      LET l_str13 = ''                               
      LET l_str13 = p011_getstr(l_nme01,l_nme27,l_nma47,'3','1','','')      
      
      #3.anmi012中抓取銀行支付信息
      LET l_noa06 = ''
      LET l_noa07 = ''
      SELECT noa06,noa07 INTO l_noa06,l_noa07 FROM noa_file
       WHERE noa01 = l_nma47  AND noa04 = '2' 
         AND noa05 = g_noa05  AND noa02 = g_noa02
         AND noa14 = '1'
      IF cl_null(l_noa06) THEN  
         LET g_success = 'N'
         CALL s_errmsg('noa01',l_nma47,"",'anm1024',1)
      END IF  

      LET l_str12 = ''  
      IF l_noa06 = '1' THEN  #XML                     
         LET l_str12 = p011_getxml(l_nme01,l_nme27,l_nma47)         
      ELSE                                        
         LET l_str12 = p011_getstr(l_nme01,l_nme27,l_nma47,'2',l_noa06,l_noa07,'')
      END IF
      
      IF g_success = 'Y' THEN
         BEGIN WORK
         
         UPDATE nme_file SET nme24 = '5' WHERE nme27 = l_nme27 AND nme01 = l_nme01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL s_errmsg('nme27',l_nme27,'UPDATE nme_file',SQLCA.sqlcode,1)
         ELSE
            CALL p011_insert_nps(l_nme27,g_noa05,'','D')
         END IF
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            LET l_success = 'N'
            CALL s_errmsg('nme01',l_nme01,l_nme27,'anm-806',1)
            ROLLBACK WORK
         END IF   
         DISPLAY l_str13,l_str12
      ELSE
         LET l_success = 'N'
         CALL s_errmsg('nme01',l_nme01,l_nme27,'anm-806',1)  
      END IF      
   END FOREACH   
   IF l_success = 'N' THEN  
      CALL s_showmsg()
   ELSE
      CALL cl_err(' ','anm-804',0)   
   END IF 
   CALL p011_b_fill(g_wc) 
END FUNCTION

#落地支付
#根據網銀接口編碼生成文件
FUNCTION p011_landing()
   DEFINE l_nma47       LIKE nma_file.nma47 #接口銀行編碼 
   DEFINE l_noa         RECORD LIKE noa_file.*
   DEFINE l_nme01       LIKE nme_file.nme01
   DEFINE l_nme27       LIKE nme_file.nme27 
   DEFINE l_str12       STRING              #完整的報文XML
   DEFINE l_i           LIKE type_file.num10 
   DEFINE output_name   STRING
   DEFINE unix_path     STRING
   DEFINE window_path   STRING 
   DEFINE l_name        STRING
   DEFINE l_channel     base.Channel
   DEFINE l_sequ        LIKE npu_file.npu03
   DEFINE l_sequ1       STRING
   DEFINE l_cmd         STRING 
   
   LET l_i = 0
   LET l_nme01 = '' 
   LET l_nma47 = ''
   LET g_noa05 = ''
   LET g_noa02 = ''
   SELECT COUNT(*) INTO l_i FROM nme_tmp1 WHERE chk = 'Y'
   IF l_i < 1 THEN
      CALL cl_err("","aic-044",1)
      RETURN
   END IF 
   
   IF NOT cl_sure(18,20) THEN RETURN END IF   
   #1.輸入交易類型 
   LET g_sql = " SELECT DISTINCT nma47 FROM nma_file,nme_tmp1 ",
               "  WHERE chk = 'Y' AND nme01 = nma01 "
   PREPARE p011_pre_n2 FROM g_sql
   EXECUTE p011_pre_n2 INTO l_nma47                
   IF cl_null(l_nma47) THEN
      CALL cl_err('','anm1019',1)
      RETURN 
   END IF   
   CALL p011_info(l_nma47)  RETURNING g_noa05,g_noa02
   IF cl_null(g_noa05) OR cl_null(g_noa02) THEN
      CALL cl_err("","anm1038",1)
      RETURN
   END IF

   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init() 
   
   DECLARE p011_nme_cs2 CURSOR FOR SELECT DISTINCT nme01 FROM nme_tmp1 WHERE chk = 'Y'
   DECLARE p011_nme_cs3 CURSOR FOR SELECT DISTINCT nme27 FROM nme_tmp1 WHERE chk = 'Y'
   FOREACH p011_nme_cs2 INTO l_nme01   
      IF cl_null(l_nme01) THEN
         CONTINUE FOREACH
      END IF 
      #根據銀行編號抓取接口銀行編碼
      SELECT nma47 INTO l_nma47 FROM nma_file WHERE nma01 = l_nme01 AND nmaacti = 'Y'
      IF cl_null(l_nma47) THEN
         LET g_success = 'N'
         CALL s_errmsg('nme01',l_nme01,'','anm1019',1)
         EXIT FOREACH
      END IF 

      INITIALIZE l_noa.* TO NULL
      SELECT * INTO  l_noa.*  FROM noa_file        
       WHERE noa01 = l_nma47  AND noa04 = '2' 
         AND noa05 = g_noa05  AND noa02 = g_noa02
         AND noa14 = '1'
      IF cl_null(l_noa.noa06) THEN  
         LET g_success = 'N'
         CALL s_errmsg('noa01',l_nma47,"",'anm1024',1)
         EXIT FOREACH
      END IF
      IF cl_null(l_noa.noa08) OR l_noa.noa08 = ' ' 
         OR cl_null(l_noa.noa12) OR l_noa.noa12 = ' ' THEN
         LET g_success = 'N'
         CALL s_errmsg('noa01',l_nma47,"",'anm1041',1)
         EXIT FOREACH
      END IF

      #創建文件
      SELECT npu03+1 INTO l_sequ FROM npu_file WHERE npu01 = l_noa.noa05 AND npu02 = TODAY 
      IF cl_null(l_sequ) OR l_sequ =0 THEN
         LET l_sequ =1
      END IF
      LET l_sequ1 = l_sequ
      IF l_noa.noa10 = '1' THEN
         LET l_name = l_noa.noa09 CLIPPED,TODAY USING "YYYYMMDD",'_',l_sequ1.trim()
      ELSE
         IF l_noa.noa10 = '2' THEN
            LET l_name = l_noa.noa09 CLIPPED,TODAY USING "YYYYMM",'_',l_sequ1.trim()
         ELSE 
            IF l_noa.noa10 = '3' THEN
               LET l_name = l_noa.noa09 CLIPPED,'_',l_sequ1.trim()
            END IF
         END IF
      END IF     

      CASE l_noa.noa11
         WHEN '1'
            LET output_name = l_name,".txt"
         WHEN '2'
            LET output_name = l_name,".dat"
         WHEN '3'
            LET output_name = l_name,".rpt"
         WHEN '4'
            LET output_name = l_name,".act" 
         WHEN '5'
            LET output_name = l_name,".csv"
      END CASE       
      LET l_channel = base.Channel.create()
      CALL l_channel.openFile(output_name,"a" )
      CALL l_channel.setDelimiter("")

      LET l_nme27 = ''
      FOREACH p011_nme_cs3 INTO l_nme27     
         #流水號作為唯一標誌，不能為空
         IF cl_null(l_nme27) OR l_nme27 = ' ' THEN
            LET g_success = 'N'
            CALL s_errmsg('nme27',l_nme27,'','anm1026',1)
            EXIT FOREACH
         END IF
         #2.anmi012中抓取銀行支付信息
         LET l_str12 = ''  
         LET l_str12 = p011_getstr(l_nme01,l_nme27,l_nma47,'2','2',l_noa.noa08,'')
         IF NOT cl_null(l_str12) THEN
            LET l_str12 = l_str12.subString(1,l_str12.getLength()-1)
            LET l_str12 = l_str12,'\r'
         END IF
         IF g_success = 'Y' THEN
            CALL l_channel.writeLine(l_str12) 
            UPDATE nme_file SET nme24 = '0' WHERE nme27 = l_nme27 AND nme01 = l_nme01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'
               CALL s_errmsg('nme27',l_nme27,'UPDATE nme_file',SQLCA.sqlcode,1)
               EXIT FOREACH
            ELSE
               CALL p011_insert_nps(l_nme27,g_noa05,output_name,'L')
               IF g_success = 'N' THEN
                  EXIT FOREACH 
               END IF   
            END IF
         ELSE   
            EXIT FOREACH 
         END IF        
      END FOREACH
      IF g_success = 'N' THEN
         EXIT FOREACH 
      END IF
      IF g_success = 'Y' THEN      
         CALL l_channel.close()
         LET unix_path = "$TEMPDIR/",output_name
         LET window_path = l_noa.noa12,output_name          
         LET status = cl_download_file(unix_path, window_path) 
         IF status THEN
            LET g_success = 'Y'
         ELSE
            LET g_success = 'N'
            EXIT FOREACH 
         END IF         
         LET l_cmd = "rm ",output_name CLIPPED," 2>/dev/null"
         RUN l_cmd  
         UPDATE npu_file SET npu03 = l_sequ WHERE npu01 = g_noa05 AND npu02 = TODAY 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            INSERT INTO npu_file VALUES(g_noa05,TODAY,l_sequ)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'
               CALL s_errmsg('noa05',g_noa05,'INSERT npu_file',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF      
         END IF       
      END IF     
   END FOREACH 
   IF g_success = 'Y' THEN
      CALL cl_err('','anm-810',0)
      COMMIT WORK
   ELSE
      CALL cl_err('','anm-809',0)
      CALL s_showmsg()
      ROLLBACK WORK
   END IF   
   CALL p011_b_fill(g_wc) 
END FUNCTION

#交易類型
FUNCTION p011_info(p_nma47)
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_noa05       LIKE noa_file.noa05
   DEFINE l_azf03       LIKE azf_file.azf03
   DEFINE l_noa02       LIKE noa_file.noa02
   DEFINE l_noa03       LIKE noa_file.noa03
   DEFINE p_nma47       LIKE nma_file.nma47
   
   LET l_noa02 = ''
   LET l_noa03 = ''
   LET l_noa05 = ''
   OPEN WINDOW p011_1_w AT 10,20 WITH FORM "anm/42f/anmp011_1"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("anmp011_1")     
          
   INPUT l_noa05,l_noa02 WITHOUT DEFAULTS FROM noa05,noa02
      AFTER FIELD noa05
         IF NOT cl_null(l_noa05) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM noa_file 
             WHERE noa05 = l_noa05 AND noa04 = '2' AND noa14 = '1'
            IF l_n > 0 THEN
               SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01 = l_noa05 AND azf02 = 'T' 
               IF cl_null(l_noa02) THEN
                  SELECT noa02,noa03 INTO l_noa02,l_noa03 FROM noa_file 
                   WHERE noa01 = p_nma47 AND noa05 = l_noa05 AND noa13 = 'Y' AND noa04 = '2' AND noa14 = '1'
                  DISPLAY l_noa02,l_noa03 TO noa02,noa03
               END IF
               DISPLAY l_azf03 TO azf03
            ELSE
               CALL cl_err(l_noa05,'anm1034',0)
               NEXT FIELD noa05
            END IF   
         END IF
      AFTER FIELD noa02
         IF NOT cl_null(l_noa02) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM noa_file 
             WHERE noa05 = l_noa05 AND noa04 = '2' AND noa01 = p_nma47 AND noa14 = '1' AND noa02 = l_noa02
            IF l_n < 1 THEN              
               CALL cl_err(l_noa02,'adm-002',0)
               NEXT FIELD noa02
            ELSE
               SELECT noa03 INTO l_noa03 FROM noa_file
                WHERE noa01 = p_nma47 AND noa05 = l_noa05 AND noa02 = l_noa02 AND noa04 = '2' AND noa14 = '1'
               DISPLAY l_noa03 TO noa03
            END IF   
         END IF   

      ON ACTION controlp
         CASE            
            WHEN INFIELD(noa05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_noa05"
               LET g_qryparam.default1= l_noa05
               LET g_qryparam.arg1 = p_nma47
               LET g_qryparam.arg2 = '1'
               CALL cl_create_qry() RETURNING l_noa05
               NEXT FIELD noa05  
            WHEN INFIELD(noa02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_noa02"
               LET g_qryparam.default1= l_noa02
               LET g_qryparam.arg1 = l_noa05
               LET g_qryparam.arg2 = p_nma47
               LET g_qryparam.arg3 = '1'
               CALL cl_create_qry() RETURNING l_noa02
               NEXT FIELD noa02     
            OTHERWISE 
               EXIT CASE
         END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about        
          CALL cl_about()    

       ON ACTION HELP         
          CALL cl_show_help()   
        
       ON ACTION controlg
          CALL cl_cmdask()
    END INPUT

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW p011_1_w
       RETURN '',''
    END IF
    CLOSE WINDOW p011_1_w
    RETURN l_noa05,l_noa02
END FUNCTION

#根據anmi012和anmi013中單身的內容組合成srting
#anmi013 默認為組成XML形式
#anmi012 nob13不為空，則為根據anmi011的類別進行組合
#        noa06 區別組合的形式 xml或者分隔符noa07隔開 
# noa04  2：anmi012
#        3: anmi013 
FUNCTION p011_getstr(p_nme01,p_nme27,p_noa01,p_noa04,p_noa06,p_noa07,p_nob13)
   DEFINE p_nme01  LIKE nme_file.nme01  #銀行編號
   DEFINE p_nme27  LIKE nme_file.nme27  #流水號
   DEFINE p_noa01  LIKE noa_file.noa01  #銀行接口編碼
   DEFINE p_noa04  LIKE noa_file.noa04  #資料類型 
   DEFINE p_nob13  LIKE nob_file.nob13 
   DEFINE p_noa06  LIKE noa_file.noa06
   DEFINE p_noa07  LIKE noa_file.noa07
   DEFINE l_nob24  LIKE nob_file.nob24
   DEFINE l_nob    RECORD LIKE nob_file.* 
   DEFINE l_value  LIKE nob_file.nob09
   DEFINE l_str    STRING
   DEFINE l_sql    STRING

   IF g_success = 'N' THEN
      RETURN  ''  
   END IF
   INITIALIZE l_nob.* TO NULL
   LET l_sql = "SELECT nob_file.* FROM nob_file ",
               " WHERE nob01 = '",p_noa01,"'",               
               "   AND nob04 = '",p_noa04,"'",               
               "   AND nob21 <> 'Y' "      
   IF p_noa04 = '2' THEN
      IF NOT cl_null(p_nob13) THEN
         LET l_sql = l_sql,"   AND nob13 = '",p_nob13,"'"   
      END IF
      LET l_sql = l_sql,"   AND nob02 = '",g_noa02,"' ",
                        "   AND nob03 = '",g_noa05,"'", 
                        "   AND nob24 = '1'",
                        " ORDER BY nob05,nob06 " 
   ELSE 
      LET l_sql = l_sql,"   AND nob02 = ' ' ",
                        "   AND nob03 = ' '", 
                        "   AND nob24 = '3'",
                        " ORDER BY nob05,nob06 "    
   END IF  
   PREPARE nob_pre2  FROM l_sql
   DECLARE nob_curs2 CURSOR FOR nob_pre2
   LET l_str = ""
   FOREACH nob_curs2 INTO l_nob.*
      LET l_value = p011_getvalue(l_nob.*,p_nme01,p_nme27)
      IF g_success = 'N' THEN
         RETURN  ''
      END IF     
      
      #組合字符串
      IF p_noa06 = '1' THEN #XML
         LET l_str = l_str,"   <",l_nob.nob06,">",l_value CLIPPED,"</",l_nob.nob06,">", ASCII 10 
      ELSE                  #分隔符
         LET l_str = l_str,l_value CLIPPED,p_noa07
      END IF             
   END FOREACH
   RETURN l_str
END FUNCTION 

#把anmi011和anmi012的內容合成一個XML
FUNCTION p011_getxml(p_nme01,p_nme27,p_noa01)
   DEFINE l_nob    RECORD LIKE nob_file.*
   DEFINE p_nme01  LIKE nme_file.nme01  #銀行編號
   DEFINE p_nme27  LIKE nme_file.nme27  #流水號
   DEFINE p_noa01  LIKE noa_file.noa01
   DEFINE l_str1   STRING
   DEFINE l_str2   STRING
   DEFINE l_sql    STRING      

   IF g_success = 'N' THEN
      RETURN  ''  
   END IF
   #anmi011的為根節點，首先列出anmi011的資料
   LET l_sql = "SELECT nob_file.* FROM nob_file ",
               " WHERE nob01 = '",p_noa01,"'",
               "   AND nob02 = '",g_noa02,"'", 
               "   AND nob03 = '",g_noa05,"'", 
               "   AND nob04 = '1'",
               "   AND nob24 = '1'",    
               " ORDER BY nob05 "   
   PREPARE nob_pre1  FROM l_sql
   DECLARE nob_curs1 CURSOR FOR nob_pre1 
   LET l_str1  = ""
   LET l_str2 = ""  
   FOREACH nob_curs1 INTO l_nob.*
      IF NOT cl_null(l_nob.nob09) THEN
         LET l_str1 = l_str1,l_nob.nob09, ASCII 10
      END IF 
      IF l_nob.nob09  MATCHES "</*"  THEN #尾節點
         CONTINUE FOREACH
      ELSE
         LET l_str2 = p011_getstr(p_nme01,p_nme27,p_noa01,'2','1','',l_nob.nob13)
         IF NOT cl_null(l_str2) THEN
            LET l_str1 = l_str1, l_str2 
         END IF    
      END IF
   END FOREACH
   RETURN l_str1
END FUNCTION

FUNCTION p011_getvalue(p_nob,p_nme01,p_nme27)
   DEFINE p_nob      RECORD LIKE nob_file.* 
   DEFINE l_nob1     RECORD LIKE nob_file.* 
   DEFINE p_nme01    LIKE nme_file.nme01  #銀行編號
   DEFINE p_nme27    LIKE nme_file.nme27  #流水號
   DEFINE l_value    LIKE nob_file.nob09   
   DEFINE l_diff     LIKE type_file.num10
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_time     LIKE type_file.chr8
   DEFINE l_str      STRING
   DEFINE l_sql      STRING
   DEFINE l_addstr   STRING
   DEFINE l_tabstr   STRING
   DEFINE field_val  STRING
   DEFINE data_val   STRING
    
   LET l_value = ""    
   LET data_val = "" 
   LET field_val = ""      
   CASE p_nob.nob08 #取值來源
      WHEN "1"     #1 固定值
         LET l_value = p_nob.nob09

      WHEN "2"     #2 從TIPTOP取值
         IF cl_null(p_nob.nob12) THEN
            LET p_nob.nob12 = " 1=1 "
         END IF
         IF p_nob.nob10 NOT MATCHES 'nme_file' THEN
            LET l_tabstr = "  nme_file, ",p_nob.nob10
         ELSE
            LET l_tabstr = p_nob.nob10
         END IF
         LET l_sql = "SELECT ",p_nob.nob11,"  FROM ",l_tabstr,                        
                     " WHERE ",p_nob.nob12,
                     "   AND nme01= '",p_nme01,"'",
                     "   AND nme27 = '",p_nme27,"' "
         PREPARE i011_pre1 FROM l_sql       
         EXECUTE i011_pre1 INTO l_value 
         IF SQLCA.sqlcode THEN 
            CALL s_errmsg('nob11',p_nob.nob11,'exe p305_pre1',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN  ''
         END IF            

      WHEN "3"     #3 序號
         LET g_xh = g_xh + 1
         LET l_value = g_xh 

      WHEN "4"     #4 從畫面取值#该取值方式暂时只用于anmp305
         LET l_value = '' 

      WHEN "5"     #5 多域串         
         DECLARE nob_curs_1 CURSOR FOR SELECT * FROM nob_file 
           WHERE nob01 = p_nob.nob01 AND nob02 = p_nob.nob02 
             AND nob03 = p_nob.nob03 AND nob04 = p_nob.nob04
             AND nob24 = p_nob.nob24 AND nob21 = 'Y'
             AND nob08 <> '5'
           ORDER BY nob05  
         FOREACH nob_curs_1 INTO l_nob1.*   
            LET field_val =  field_val,l_nob1.nob06,l_nob1.nob22
            LET l_value = p011_getvalue(l_nob1.*,p_nme01,p_nme27)
            LET data_val = data_val,l_value,l_nob1.nob22
            IF g_success = 'N' THEN
               RETURN  ''
            END IF 
         END FOREACH
         LET l_value =  field_val CLIPPED,data_val CLIPPED         

      WHEN "6"    #當前日期
         IF NOT cl_null(p_nob.nob09) THEN
            LET l_value = g_today USING p_nob.nob09
         ELSE
            LET l_value = g_today
         END IF

      WHEN "7"    #當前時間 
         IF NOT cl_null(p_nob.nob09) THEN
           LET l_i = LENGTH(p_nob.nob09)
           LET l_time = TIME
           IF p_nob.nob09 MATCHES "*:*" THEN
              LET l_value = l_time
           ELSE
              LET l_value = l_time[1,2],l_time[4,5],l_time[7,8] 
           END IF
           LET l_value = l_value[1,l_i]
         ELSE
            LET l_value = l_time
         END IF
   END CASE 
   IF p_nob.nob04 = '2' AND p_nob.nob08 <> '5'  THEN
      #是否必輸nob14
      IF cl_null(l_value) AND p_nob.nob14 = 'Y' THEN 
         LET g_success = 'N'
         CALL s_errmsg('nob06',p_nob.nob06,"nob14 = Y",'anm1021',1)
         RETURN ''
      END IF  
      #是否控制小數位數nob19 nob20
      IF p_nob.nob19 = 'Y' THEN
         LET l_value = cl_set_num_value(l_value,p_nob.nob20)
      END IF
      #是否需補字符nob16 nob17 nob18
      LET l_diff = 0
      LET l_addstr = ''
      IF p_nob.nob16 = 'Y' THEN
         IF LENGTH(p_nob.nob17) > 1 THEN
            LET g_success = 'N'
            CALL s_errmsg('nob17',p_nob.nob17,"",'abm-811',1)
            RETURN ''
         END IF
         LET l_diff = p_nob.nob15 - LENGTH(l_value)
         IF l_diff > 0 THEN      
            FOR l_i = 1 TO l_diff 
               LET l_addstr = l_addstr,p_nob.nob17
            END FOR   
            IF p_nob.nob18 = '01' THEN
               lET l_value = l_addstr,l_value
            ELSE
               LET l_value = l_value,l_addstr
            END IF
         END IF
      END IF
      #最大長度nob15
      IF NOT cl_null(p_nob.nob15) AND LENGTH(l_value) > p_nob.nob15 THEN
         LET g_success = 'N'
         CALL s_errmsg('nob06',p_nob.nob06,p_nob.nob15,'anm1020',1)
         RETURN  ''
      END IF 
   END IF   
   RETURN l_value
END FUNCTION

#支付完成后，nps_file寫入資料
FUNCTION p011_insert_nps(p_nme27,p_noa05,p_name,p_flag)
   DEFINE p_nme27    LIKE nme_file.nme27
   DEFINE p_noa05    LIKE noa_file.noa05 
   DEFINE p_flag     LIKE type_file.chr1 
   DEFINE l_nps      RECORD LIKE nps_file.*
   DEFINE l_nme      RECORD LIKE nme_file.*
   DEFINE p_name     STRING
   DEFINE l_sql      STRING
   DEFINE l_str      STRING    
   
   IF cl_null(p_nme27) THEN
      RETURN
   END IF
   INITIALIZE l_nps.* TO NULL
   INITIALIZE l_nme.* TO NULL 
   SELECT * INTO l_nme.* FROM nme_file WHERE nme27 =  p_nme27 
   LET l_str = l_nme.nme21
   LET l_nps.nps01 = l_nme.nme22 CLIPPED,'_',l_nme.nme12 CLIPPED,'_',l_str.trim()               
   SELECT rtrim(ltrim(nmt09)) INTO l_nps.nps06 FROM nmt_file,nma_file WHERE nmt01 = nma39 AND nma01 = l_nme.nme01          
   SELECT nma04,nma10 INTO l_nps.nps05,l_nps.nps13 FROM nma_file WHERE nma01 = l_nme.nme01          
   LET l_nps.nps12 = l_nme.nme08          
   LET l_nps.nps16 = l_nme.nme05
   LET l_nps.nps17 = l_nme.nme24
   LET l_nps.nps29 = l_nme.nme15
   SELECT nmt09,nmt12 INTO l_nps.nps18,l_nps.nps19 FROM nmt_file,nma_file WHERE nmt01 = nma39 AND nma01 = l_nme.nme01  
   LET l_nps.nps03 = p_noa05 
   LET l_nps.nps23 = TODAY   
   IF p_flag = 'L' THEN   
      LET l_nps.nps25 = p_name CLIPPED
   END IF 
   SELECT pmf03 INTO l_nps.nps07 FROM pmf_file WHERE pmf01 = l_nme.nme25 AND pmf05 ='Y' AND pmfacti = 'Y'
   SELECT pmf04 INTO l_nps.nps08 FROM pmf_file WHERE pmf01 = l_nme.nme25 AND pmf05 ='Y' AND pmfacti = 'Y'
   SELECT nmt02 INTO l_nps.nps09 FROM nmt_file,pmf_file WHERE nmt01 =pmf02 AND pmf01 = l_nme.nme25 AND pmf05 ='Y' AND pmfacti ='Y'
   SELECT nmt06 INTO l_nps.nps10 FROM nmt_file,pmf_file WHERE nmt01 =pmf02 AND pmf01 = l_nme.nme25 AND pmf05 ='Y' AND pmfacti ='Y'
   SELECT nmt07 INTO l_nps.nps11 FROM nmt_file,pmf_file WHERE nmt01 =pmf02 AND pmf01 = l_nme.nme25 AND pmf05 ='Y' AND pmfacti ='Y'   
   INSERT INTO nps_file VALUES(l_nps.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('nps01',l_nps.nps01,'ins nps_file',SQLCA.sqlcode,1)
      LET g_success = 'N' 
   END IF
END FUNCTION
#FUN-B30213--end--
