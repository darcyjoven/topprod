# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_msfslip.4gl
# Descriptions...: 檢查所輸入之單別是否正確
# Date & Author..: 92/05/15 By Lee
# Usage..........: CALL s_msfslip(p_slip,p_sys,p_kind)
# Input Parameter: p_slip  單別
#                  p_sys   系統別
#                  p_kind  單據性質
# Return code....: NONE
# Memo...........: 1.g_smy 該單別相關的設定資料
#                  2.g_errno 錯誤時的錯誤代號
# Revise record..: 97/07/21 By Roger 加上 g_user 是否有該單別的使用權限
# Modify.........: No.MOD-660032 06/06/19 By Pengu 單別之部門檢核應一致捉取p_zx之部門資料
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #No.FUN-680147   #FUN-7C0053
 
DEFINE g_gen03 LIKE gen_file.gen03             #部門代號
 
FUNCTION s_mfgslip(p_slip,p_sys,p_kind)
DEFINE
	p_slip LIKE smy_file.smyslip,		#單別
	p_sys  LIKE smy_file.smysys,		#系統別
	p_kind LIKE smy_file.smykind,		#單據性質
	l_n	LIKE type_file.num10            #No.FUN-680147 INTEGER
 
	WHENEVER ERROR CALL cl_err_msg_log
 
 
        LET p_sys = UPSHIFT(p_sys)   #TQC-670008 add
 
        SELECT * INTO g_smy.* FROM smy_file
	   #WHERE smyslip=p_slip AND smysys=p_sys        #TQC-670008 remark
	   WHERE smyslip=p_slip AND upper(smysys)=p_sys  #TQC-670008
	CASE 	WHEN SQLCA.SQLCODE = 100   LET g_errno='mfg0014'#無此單別
		WHEN g_smy.smykind!=p_kind LET g_errno='mfg0015'#單據性質不符
		WHEN g_smy.smyacti='N'     LET g_errno='9028'	#無效資料
		OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
	END CASE
	#-------------------------------- g_user 是否有該單別的使用權限(970717)
	#NO:6842
      #--------------No.MOD-660032 modify
       #SELECT gen03 INTO g_gen03 FROM gen_file where gen01=g_user   #抓此人所屬部門
        SELECT zx03 INTO g_gen03 FROM zx_file where zx01=g_user   #抓此人所屬部門
      #--------------No.MOD-660032 end
        IF SQLCA.SQLCODE THEN
            LET g_gen03=NULL
        END IF
        #權限先check user再check部門
        #SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=p_slip AND smu03=p_sys    #CHECK USER        #TQC-670008 remark
        SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=p_slip AND upper(smu03)=p_sys    #CHECK USER  #TQC-670008
        IF l_n>0 THEN                                                                 #USER權限存有資料,並g_user判斷是否存在
           #SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=p_slip AND smu02=g_user AND smu03=p_sys        #TQC-670008 remark
           SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=p_slip AND smu02=g_user AND upper(smu03)=p_sys  #TQC-670008
           IF l_n=0 THEN
               IF g_gen03 IS NULL THEN                               #g_user沒有部門           
                   LET g_errno='aoo-104' 
               ELSE
                   #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=p_slip AND smv02=g_gen03 AND smv03=p_sys  #CHECK g_user部門是否存在        #TQC-670008 remark
                   SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=p_slip AND smv02=g_gen03 AND upper(smv03)=p_sys  #CHECK g_user部門是否存在  #TQC-670008
                   IF l_n=0 THEN
                       LET g_errno='aoo-104' 
                   END IF
               END IF
           END IF
        ELSE
           #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=p_slip AND smv03=p_sys #CHECK Dept        #TQC-670008 remark
           SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=p_slip AND upper(smv03)=p_sys #CHECK Dept  #TQC-670008
            IF l_n>0 THEN
               IF g_gen03 IS NULL THEN                                #g_user沒有部門              
                   LET g_errno='aoo-104' 
               ELSE
                   #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=p_slip AND smv02=g_gen03 AND smv03=p_sys  #CHECK g_user部門是否存在        #TQC-670008 remark
                   SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=p_slip AND smv02=g_gen03 AND upper(smv03)=p_sys  #CHECK g_user部門是否存在  #TQC-670008
                   IF l_n=0 THEN
                        LET g_errno='aoo-104' 
                   END IF
               END IF             
            END IF
        END IF     
        #NO:6842
        #----------------------------------------------------------------
	IF NOT cl_null(g_errno) THEN LET g_smy.smydesc='' END IF
END FUNCTION
