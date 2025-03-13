# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfp610.4gl
# Descriptions...: 備料資料產生作業
# Date & Author..: 92/08/07 By Pin   
# Modify.........: No.TQC-610003 06/01/17 By Nicola Call s_cralc時，多傳一個參數 
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
# Modify.........: No.MOD-630061 06/03/15 By Claire 排除 sfb02 != '8 '
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680121 06/09/04 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-8A0210 08/10/23 By claire 排除作廢工單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BC0008 11/12/02 By zhangll s_cralc4整合成s_cralc,s_cralc增加傳參
# Modify.........: No.TQC-D70074 13/07/22 By lujh 1.“工單編號”，“生產料件”欄位建議增加開窗
#                                                 2.無法ctrl+g
#                                                 3.幫助文檔為灰色，無法打開help文件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    l_cmd    LIKE type_file.chr1000,    #string command variable        #No.FUN-680121 VARCHAR(100)
          m_status LIKE type_file.chr1,       #No.FUN-680121 VARCHAR(1)#reset version/effective/routing
                                              # Y/N  
        g_sfb DYNAMIC ARRAY OF RECORD         #
            sfb01  LIKE sfb_file.sfb01,       #W.O NO.
            sfb05  LIKE sfb_file.sfb05,       #part no.
            sfb07  LIKE sfb_file.sfb07,       #version no.
            sfb071 LIKE sfb_file.sfb071       #effective date.
        END RECORD,
        l_sfb DYNAMIC ARRAY OF RECORD            #
            sfb02  LIKE sfb_file.sfb02,       #W.O type.
            sfb04  LIKE sfb_file.sfb04,       #W.O status.
            sfb06  LIKE sfb_file.sfb06,       #Primary Code
            sfb08  LIKE sfb_file.sfb08,       #part number.
            sfb95  LIKE sfb_file.sfb95   #No.TQC-610003
        END RECORD,
        g_cmd        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(60)
        g_rec_b      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        s_t          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_exit_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_ac,l_sl    LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680121 INTEGER
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
#--->@@@可否執行該作業未判斷
   CALL p610_cmd(0,0)          #condition input
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION p610_cmd(p_row,p_col)
    DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_flag   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    LET p_row = 3 LET p_col = 25
    OPEN WINDOW p610_w AT p_row,p_col WITH FORM "asf/42f/asfp610" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
    WHILE TRUE
        IF s_shut(0) THEN RETURN END IF
        CLEAR FORM 
        CALL g_sfb.clear()
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
       CONSTRUCT l_cmd ON sfb01,sfb05 FROM a,b  #QBE 輸入條件
          ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         #TQC-D70074--add--str--
         ON ACTION controlp
           CASE
              WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_sfb01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO a
                  NEXT FIELD a
              WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_sfb05_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO b
                  NEXT FIELD b
              OTHERWISE
                 EXIT CASE
           END CASE

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION help
            CALL cl_show_help()
         #TQC-D70074--add--end--        

        END CONSTRUCT
        LET l_cmd = l_cmd CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
        IF INT_FLAG THEN LET INT_FLAG = 0 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
           EXIT PROGRAM  
        END IF
#----->第二階段以輸入方式輸入
        LET m_status='N'
        INPUT m_status WITHOUT DEFAULTS FROM c 
            AFTER FIELD c
                IF m_status IS NULL THEN 
                    NEXT FIELD  c 
                END IF  
                IF m_status NOT MATCHES '[yYnN]' THEN
                   NEXT FIELD m_status
                END IF
 
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
 
            ON ACTION CONTROLG
               CALL cl_cmdask()
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
            ON ACTION exit                            #加離開功能
               LET INT_FLAG = 1
               EXIT INPUT    
  
            #TQC-D70074--add--str--
            ON ACTION help
               CALL cl_show_help()
            #TQC-D70074--add--end--
        
        END INPUT
        IF INT_FLAG THEN LET INT_FLAG = 0 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
           EXIT PROGRAM  
        END IF
        CALL p610_fill() returning s_t    #抓取符合資料填入陣列
        IF  s_t <=0 THEN                  #無符合之資料
            CALL cl_err( ' ','mfg3122',0)
            CONTINUE  WHILE 
        END IF
        CALL p610_bp()
        IF m_status MATCHES '[Yy]' THEN 
           CALL p610_array()
        END IF
        IF cl_sure(0,0) THEN
           BEGIN WORK
           LET g_success='Y'
           CALL p610_gen()     # ----->正式產生備料資料-------
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              EXIT WHILE
           END IF
        END IF
    END WHILE
    ERROR ""
    CLOSE WINDOW p610_w
END FUNCTION
 
FUNCTION p610_fill()
#     DEFINE    l_time LIKE type_file.chr8        #No.FUN-6A0090
      DEFINE   l_wc         LIKE type_file.chr1000,  # RDSQL STATEMENT  #No.FUN-680121 VARCHAR(200) #No.FUN-6A0090
               l_sql        LIKE type_file.chr1000,  # RDSQL STATEMENT  #No.FUN-680121 VARCHAR(610)
               l_no,l_cnt   LIKE type_file.num5      #No.FUN-680121 SMALLINT
 
    UPDATE sfb_file SET sfb071=' ' WHERE sfb071 IS NULL
    LET l_sql = "  SELECT sfb01,sfb05,sfb07,sfb071,sfb02,sfb04,sfb06,sfb08,sfb95 ",  #No.TQC-610003
                "  FROM sfb_file",
                "  WHERE sfb04 IN ('1','2') ",      #確認工單
                "    AND sfb23 NOT IN ('y','Y') ",  #未產生備料資料
                "    AND sfbacti='Y' " ,              #有效之資料
            #   "    AND sfb02 != 7 ",                 #MOD-630061 mark
                "    AND (sfb02 != 7 AND sfb02 != 8)", #MOD-630061
            #   "    AND sfb01 NOT IN (select sfa01 from sfa_file) ",
                "    AND sfb87 <> 'X' ",  #MOD-8A0210 add
                "    AND ",l_cmd CLIPPED,
                "    ORDER BY sfb071 "
 
    PREPARE p610_prepare FROM l_sql #prepare it
    DECLARE p610_cur CURSOR FOR p610_prepare
    LET l_ac = 1
    FOR l_ac=1 TO g_sfb.getLength()
        INITIALIZE g_sfb[l_ac].* TO NULL
    END FOR
    LET l_ac = 1
    FOREACH p610_cur INTO g_sfb[l_ac].*,l_sfb[l_ac].*  
        IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('cannot foreach ',SQLCA.sqlcode,1) EXIT FOREACH   #No.FUN-660128
        END IF
        CALL SET_COUNT(l_ac)
        LET g_rec_b=l_ac
        DISPLAY g_rec_b TO FORMONLY.cn2  
        LET g_cnt = 0
        LET l_ac = l_ac + 1
        LET l_cnt = l_cnt + 1
     #TQC-630106-begin 
      #IF l_ac > g_max_rec THEN EXIT FOREACH END IF
      IF l_ac > g_max_rec THEN 
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
     #TQC-630106-end 
    END FOREACH
    CALL SET_COUNT(l_ac - 1)
    RETURN l_cnt
END FUNCTION
   
FUNCTION p610_array()
    DEFINE
          l_n,l_ac,l_sl    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_return         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_effect         LIKE type_file.dat,           #No.FUN-680121 DATE
          l_loss           LIKE type_file.dat,           #No.FUN-680121 DATE
          l_exit_sw        LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
    INPUT ARRAY g_sfb WITHOUT DEFAULTS FROM s_sfb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
        BEFORE ROW
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
 
        AFTER FIELD sfb07
            IF g_sfb[l_ac].sfb01 IS NOT NULL
                AND g_sfb[l_ac].sfb05 IS NOT NULL THEN
                IF g_sfb[l_ac].sfb07 IS NOT NULL AND g_sfb[l_ac].sfb07 !=' '
                    THEN CALL s_version(g_sfb[l_ac].sfb05,g_sfb[l_ac].sfb07)
                              RETURNING l_effect,l_loss,l_return
                    IF l_return = 1 THEN 
                        CALL cl_err(g_sfb[l_ac].sfb07,'mfg6160',0)
                        NEXT FIELD sfb07
                    END IF
                    LET g_sfb[l_ac].sfb071 = l_effect
                END IF
            END IF
 
        AFTER FIELD  sfb071
            IF NOT cl_null(g_sfb[l_ac].sfb01) AND NOT cl_null(g_sfb[l_ac].sfb05)            THEN
               IF NOT cl_null(g_sfb[l_ac].sfb07) THEN 
                  IF cl_null(g_sfb[l_ac].sfb071) THEN 
                      CALL cl_err(g_sfb[l_ac].sfb071,'mfg6150',0)
                      NEXT FIELD sfb071
                  ELSE
                     IF g_sfb[l_ac].sfb071 < l_effect OR 
                        g_sfb[l_ac].sfb071 >= l_loss THEN
                        CALL cl_err(g_sfb[l_ac].sfb071,'mfg6161',0)
                        NEXT FIELD sfb071
                     END IF
                  END IF
               END IF
            END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END   
 
        #TQC-D70074--add--str--
        ON ACTION help
           CALL cl_show_help()

        ON ACTION controlg
           CALL cl_cmdask()
        #TQC-D70074--add--end--
    END INPUT
    IF INT_FLAG THEN  LET INT_FLAG=0 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM 
    END IF
END FUNCTION
 
FUNCTION p610_bp()
 
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b) 
 
        BEFORE DISPLAY
           IF m_status MATCHES '[Yy]' THEN 
              EXIT DISPLAY
           END IF
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
   ON ACTION confirm 
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
        ON ACTION exit        LET g_action_choice="exit"       RETURN 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
    
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
#---->核對BOM產生備料檔
FUNCTION  p610_gen()
DEFINE  i   LIKE type_file.num5,     #dimension point        #No.FUN-680121 SMALLINT
        l_msg LIKE ze_file.ze03,             #No.FUN-680121 VARCHAR(10)#message string
        t_msg LIKE type_file.chr1000,        #No.FUN-680121 VARCHAR(70)#message string
	l_minopseq LIKE ecb_file.ecb03,
        l_aloc LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        p_chr  LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)#answer Y/N
 
    FOR i=1 TO g_sfb.getLength()
        IF g_sfb[i].sfb01 IS NULL OR  g_sfb[i].sfb05 IS NULL
            THEN EXIT FOR
        END IF
        LET l_aloc = 'Y'
        #在工單發放時才產生備料資料,並工單為確認生產工單,則不產生備料資料
        IF g_sma.sma27='2' AND l_sfb[i].sfb04='1' THEN LET l_aloc='N' END IF
        IF l_aloc='Y' THEN
			CALL s_minopseq(g_sfb[i].sfb05,l_sfb[i].sfb06,g_sfb[i].sfb071)
				RETURNING l_minopseq
            CALL s_cralc(g_sfb[i].sfb01,l_sfb[i].sfb02,g_sfb[i].sfb05,
               #------------No.FUN-670041 modify
               #g_sma.sma29,l_sfb[i].sfb08,g_sfb[i].sfb071,'Y',g_sma.sma71,
                'Y',l_sfb[i].sfb08,g_sfb[i].sfb071,'Y',g_sma.sma71,
               #------------No.FUN-670041 end
              #l_minopseq,l_sfb[i].sfb95)  #No.TQC-610003
               l_minopseq,'',l_sfb[i].sfb95)  #No.TQC-610003  #FUN-BC0008 mod
                RETURNING g_cnt
 
            IF NOT cl_null(g_errno) THEN            #產生備料資料時發生問題
               OPEN WINDOW p610_w2 AT 18,2 WITH 3 ROWS, 77 COLUMNS
                                    
               CALL cl_getmsg('mfg6151',g_lang) RETURNING l_msg
               CALL cl_getmsg(g_errno,g_lang) RETURNING t_msg
               IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
                  MESSAGE l_msg clipped,g_sfb[i].sfb01 
                  CALL ui.Interface.refresh()
               ELSE 
                  DISPLAY l_msg clipped,g_sfb[i].sfb01 AT 1,1 
               END IF
               LET p_chr = ''
               WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT t_msg clipped FOR CHAR p_chr
                     ON IDLE g_idle_seconds
                        CALL cl_on_idle()
#                        CONTINUE PROMPT
                  
                  END PROMPT
                  IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW p610_w2
                     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
                         EXIT PROGRAM 
                  END IF
                  IF p_chr IS NOT NULL AND p_chr MATCHES "[YyNn]" THEN 
                     CLOSE WINDOW p610_w2
                     EXIT WHILE
                  END IF
               END WHILE
               IF p_chr MATCHES '[nN]' THEN
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
                   EXIT PROGRAM
               ELSE 
                   CONTINUE FOR
               END IF
            END IF
            UPDATE sfb_file SET sfb23='Y',
                    sfb07=g_sfb[i].sfb07,
                   sfb071=g_sfb[i].sfb071 
                   WHERE sfb01=g_sfb[i].sfb01
            IF STATUS THEN LET g_success='N' END IF
        END IF
    END FOR
END FUNCTION
 
