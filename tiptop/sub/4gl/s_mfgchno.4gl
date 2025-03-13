# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_mfgchno.4gl
# Descriptions...: 檢查所輸入之單號是否正確
# Date & Author..: 92/05/15 By Lee
# Usage..........: CALL s_mfgchno(p_slip) RETURNING l_stat,l_slip
# Input Parameter: p_slip   單號
# Return code....: l_stat   結果碼 1:OK, 0:FAIL
#                  l_slip   單號
# Modify.........: No.FUN-560060 05/06/18 By wujie 單據編號修改
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-720003 07/02/04 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"     #FUN-7C0053
 
GLOBALS
DEFINE
        g_waitsec       LIKE type_file.num5,             #No.FUN-680147 SMALLINT
        g_log           LIKE type_file.chr1              #No.FUN-680147 VARCHAR(1)
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
END GLOBALS
 
FUNCTION s_mfgchno(p_slip)
DEFINE
	p_slip LIKE sfb_file.sfb01,
	l_stat LIKE type_file.num5             #No.FUN-680147 SMALLINT
 
	IF g_smy.smyauno='N' THEN RETURN TRUE,p_slip END IF
	CALL s_chno(p_slip) RETURNING l_stat,p_slip
	IF NOT cl_null(g_errno) THEN 
#       CALL cl_err(p_slip,g_errno,0)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',p_slip,g_errno,0)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(p_slip,g_errno,0)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end
        END IF
	RETURN l_stat,p_slip
END FUNCTION
 
FUNCTION s_chno(p_slip)
DEFINE
	p_slip LIKE sfb_file.sfb01,		      #單號
	l_no LIKE smy_file.smymxno,                   #No.FUN-680147 VARCHAR(10)             #No.FUN-560060
	l_int,l_int2 LIKE type_file.num10,            #No.FUN-680147 INTEGER
	l_i LIKE type_file.num5,                      #No.FUN-680147 SMALLINT
	l_c LIKE type_file.chr1,                      #No.FUN-680147 VARCHAR(1)
	l_slip LIKE smy_file.smyslip		      #單別
DEFINE  l_format       STRING                         #No.FUN-560060 
 
	WHENEVER ERROR CALL cl_err_msg_log
 
	#沒有輸入單號
	LET g_errno=' '
#	LET l_no=p_slip[5,10]
	LET l_no=p_slip[g_no_sp,g_no_ep]              #No.FUN-560060
	IF l_no=' ' OR l_no IS NULL THEN RETURN TRUE,p_slip END IF
 
	#檢查是否有文字及是否有空白
#	FOR l_i=1 TO 6
	FOR l_i=1 TO (g_no_ep-g_no_sp+1)
		LET l_c=l_no[l_i,l_i]
    ######94/10/03 Modify By Jackson
      ##IF l_c!=' ' AND l_c NOT MATCHES '[0-9]' THEN
		IF cl_null(l_c)  THEN
			LET g_errno='mfg0084'
			RETURN FALSE,p_slip
		END IF
	END FOR
 
	#宣告一個可以將資料鎖住的
	LET l_slip=p_slip[1,g_doc_len]          #No.FUN-560060
        LET g_forupd_sql = "SELECT smymxno FROM smy_file WHERE smyslip=? AND smyacti='Y' FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE smy_curl CURSOR FROM g_forupd_sql
 
	#設定成等待的模式
 
	#讀資料
	BEGIN WORK
 	OPEN smy_curl USING l_slip              # MOD-510143
	IF SQLCA.sqlcode = "-263" THEN
#          CALL cl_err('LOCK Failed:',SQLCA.sqlcode,0)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','LOCK Failed:',SQLCA.sqlcode,0)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('LOCK Failed:',SQLCA.sqlcode,0)                                                                       
      END IF                                                                                                                        
#No.FUN-720003--end       
           CLOSE smy_curl
           LET g_errno=SQLCA.SQLCODE USING '------'
           RETURN FALSE,p_slip	#失敗
	END IF
	FETCH smy_curl INTO g_smy.smymxno	# LOCK單據性質
	IF SQLCA.sqlcode = "-263" THEN
#  	CALL cl_err('LOCK Failed:',SQLCA.sqlcode,0)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','LOCK Failed:',SQLCA.sqlcode,0)                                                                        
      ELSE                                                                                                                          
         CALL cl_err('LOCK Failed:',SQLCA.sqlcode,0)                                                                                
      END IF                                                                                                                        
#No.FUN-720003--end           
		CLOSE smy_curl
        
		LET g_errno=SQLCA.SQLCODE USING '------'
		RETURN FALSE,p_slip	#失敗
	END IF
 
	#恢復原狀
    
	#左邊補零
#No.FUN-560060--begin
	IF LENGTH(l_no)!=(g_no_ep-g_no_sp+1) THEN   
		LET g_errno='mfg0086'
                FOR l_int = g_no_sp TO g_no_ep                                                                                                    
                    LET l_no = l_no,"0"                                                                                          
                    LET l_format = l_format,"&"                                                                                          
                END FOR                                                                                                                    
		LET p_slip[g_no_sp,g_no_ep]=l_no  USING l_format
#		LET l_int=l_no LET l_no=l_int USING '&&&&&&'
#		LET p_slip[5,10]=l_no
#No.FUN-560060--end  
	END IF
 
	#單號不連續
	LET l_int=l_no
	LET l_int2=g_smy.smymxno+1
	IF l_int!=l_int2 THEN LET g_errno='mfg0085' END IF
 
	#更新已使用單號
	IF l_int>(l_int2-1) THEN
		LET g_smy.smymxno=l_no
		UPDATE smy_file 
			SET smymxno=g_smy.smymxno
			WHERE CURRENT OF smy_curl
	END IF
 
	CLOSE smy_curl
	IF g_log='Y' THEN COMMIT WORK END IF
 
	RETURN TRUE,p_slip
END FUNCTION
