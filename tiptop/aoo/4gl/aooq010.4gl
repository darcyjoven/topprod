# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aooq010.4gl
# Descriptions...: 週期期間查詢 
# Argument.......: 
# Returning......: 
# Date & Author..: 91/12/11 By Sara
# Modify.........: No.MOD-530124 05/03/24 By pengu 修改跨年度產生兩個第一週的情況 
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6C0063 06/12/27 By jamie 增加action "accept"(雙按單身時會關掉)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    g_buf   LIKE type_file.chr1000,       #No.FUN-680102CHAR(45),
          g_n     LIKE type_file.num5           #No.FUN-680102SMALLINT
 
 
DEFINE   g_i             LIKE type_file.num5,    #count/index for any purpose        #No.FUN-680102 SMALLINT
         g_rec_b         LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   CALL q010()	
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION q010()
	 DEFINE	p_row,p_col	LIKE type_file.num5,          #No.FUN-680102 SMALLINT
   		g_azn_t         RECORD
                                azn05 LIKE azn_file.azn05,
   				azn01 LIKE azn_file.azn01,
				azn02 LIKE azn_file.azn02,
				azn03 LIKE azn_file.azn03,
                                azn04 LIKE azn_file.azn04
			END RECORD,
   		g_azn_o         RECORD
                                azn05 LIKE azn_file.azn05,
   				azn01 LIKE azn_file.azn01,
				azn02 LIKE azn_file.azn02,
				azn03 LIKE azn_file.azn03,
                                azn04 LIKE azn_file.azn04
			END RECORD,
   		g_azn   DYNAMIC ARRAY OF RECORD
                                azn05 LIKE azn_file.azn05,
   				azn01_b LIKE azn_file.azn01,
   				azn01_e LIKE azn_file.azn01,
				azn02  LIKE azn_file.azn02,
				azn03  LIKE azn_file.azn03,
                                azn04  LIKE azn_file.azn04
			END RECORD,
		l_n,l_ac,l_sl	LIKE type_file.num5,           #No.FUN-680102 SMALLINT
		l_exit_sw	LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
		l_wc  		LIKE type_file.chr1000,        #No.FUN-680102CHAR(1000),
		l_sql 		LIKE type_file.chr1000,        #No.FUN-680102CHAR(1000),
		l_priv		LIKE cre_file.cre08,           #No.FUN-680102 VARCHAR(10),
                g_azn01_y    LIKE azn_file.azn01  
#       l_time                LIKE type_file.chr8		    #No.FUN-6A0081
 
 
   IF (NOT cl_user()) THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
   END IF
  
   CALL cl_chk_err_setting()
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   #IF NOT cl_prich2('aooq010','')
   #   THEN RETURN
   #END IF
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   LET p_row = 4 LET p_col = 10
   OPEN WINDOW q010_w AT p_row,p_col
	WITH FORM "aoo/42f/aooq010" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF s_shut(0) THEN
      CLOSE WINDOW p400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF
   WHILE TRUE
     LET l_exit_sw = "y"
     CALL cl_opmsg('q')
     CONSTRUCT l_wc ON azn05,azn01,azn02,azn03,azn04 FROM
                   s_azn[1].azn05,s_azn[1].azn01_b,
                   s_azn[1].azn02,s_azn[1].azn03,s_azn[1].azn04 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
     LET l_wc = l_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
     IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
 
     INITIALIZE g_azn_o.* TO NULL
 
     CALL g_azn.clear()
     CALL cl_opmsg('w')
     ###############
     LET l_sql = "SELECT azn05,azn01,azn02,azn03,azn04 FROM azn_file",
                 " WHERE ",l_wc CLIPPED,
                 " ORDER BY azn01,azn05"
     PREPARE q010_prepare FROM l_sql
     DECLARE azn_curs CURSOR FOR q010_prepare
 
     LET g_rec_b = 0
     LET l_ac = 1
     FOREACH azn_curs INTO g_azn_t.*
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode != 0 
           THEN 
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
        END IF
        IF WEEKDAY(g_azn_t.azn01) = 0 OR                #星期日
           cl_null(g_azn[l_ac].azn01_b) THEN
           LET g_azn[l_ac].azn05 = g_azn_t.azn05        #週次
           LET g_azn[l_ac].azn01_b = g_azn_t.azn01      #起始日期
        END IF
           
        IF g_azn_o.azn02<>g_azn_t.azn02    #跨年度時
           AND NOT cl_null(g_azn_o.azn02) THEN
           LET g_azn[l_ac].azn01_e = g_azn_o.azn01      #截止日期
           LET g_azn[l_ac].azn02 = g_azn_o.azn02        #年度
           LET g_azn[l_ac].azn03 = g_azn_o.azn03        #季別
           LET g_azn[l_ac].azn04 = g_azn_o.azn04        #期別
          #--------No.MOD-530124-----------------------------------
          IF WEEKDAY(g_azn_t.azn01) >0 THEN 
             LET l_ac = l_ac + 1
             LET g_azn[l_ac].azn05 = g_azn_t.azn05        #週次
             LET g_azn[l_ac].azn01_b = g_azn_t.azn01      #起始日期
          END IF 
         #--------No.MOD-530124 END-----------------------------------
        END IF
        IF WEEKDAY(g_azn_t.azn01) = 6 THEN  # 星期六
           LET g_azn[l_ac].azn01_e = g_azn_t.azn01
           LET g_azn[l_ac].azn02 = g_azn_t.azn02
           LET g_azn[l_ac].azn03 = g_azn_t.azn03
           LET g_azn[l_ac].azn04 = g_azn_t.azn04
           LET l_ac = l_ac + 1
        END IF 
        LET g_azn_o.*=g_azn_t.*
     END FOREACH
     IF cl_null(g_azn[l_ac].azn01_e) AND NOT cl_null(g_azn[l_ac].azn01_b) THEN
        LET g_azn[l_ac].azn01_e = g_azn_t.azn01
        LET g_azn[l_ac].azn02 = g_azn_t.azn02
        LET g_azn[l_ac].azn03 = g_azn_t.azn03
        LET g_azn[l_ac].azn04 = g_azn_t.azn04
        LET l_ac = l_ac + 1
     END IF
{
   ####### 98/05
          SELECT COUNT(azn05) 
          INTO   g_cn  
          FROM azn_file 
          WHERE azn02 = '",g_azn_t.azn02,"' 
          AND azn05='1'
            IF  g_cnt < 7 AND g_cnt > 0  THEN 
                  LET g_azn01_y= g_azn[1].azn01_e - 6
                  LET g_azn[1].azn01_b= g_azn01_y 
                  LET g_azn[1].azn05='1'  
            END IF        
     ###############
}
     CALL cl_set_act_visible("accept,cancel", FALSE)
     DISPLAY ARRAY g_azn TO s_azn.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE ROW
             LET l_ac = ARR_CURR()
             IF g_azn[l_ac].azn05 IS NOT NULL THEN
              DISPLAY g_azn[l_ac].azn05 TO s_azn[l_sl].azn05 
             END IF
           # NEXT FIELD azn05
          AFTER ROW
             DISPLAY g_azn[l_ac].azn05 TO
                     s_azn[l_sl].azn05
          ON ACTION CONTROLN 
             LET l_exit_sw = 'n'
             CLEAR FORM
             EXIT DISPLAY
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG 
             CALL cl_cmdask()    # Command execution
       
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DISPLAY
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
          
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
    
          ON ACTION exit
             EXIT WHILE
 
          ON ACTION accept        #TQC-6C0063 add
             CONTINUE DISPLAY     #TQC-6C0063 add
 
     END DISPLAY
     CALL cl_set_act_visible("accept,cancel", TRUE)
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     IF l_exit_sw = "y" THEN EXIT WHILE  END IF
   END WHILE
   CLOSE WINDOW q010_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   RETURN
END FUNCTION
