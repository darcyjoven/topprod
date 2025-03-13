# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: s_command.4gl
# Descriptions...: 傳程式代號return異動命令
# Date & Author..: 92/06/24 By MAY 
# Usage..........: CALL s_command(p_prono) RETURNING l_key,l_sts
# Input Parameter: p_prono  程式代號
# Return code....: l_key    異動命令
#                     1  出庫
#                     2  入庫
#                     3  調整
#                     4  出/入庫
#                  l_sts    異動方式說明
# Modify.........: No.FUN-570036 05/07/18 By Carrier 加aimt3801/aimt3802
# Modify.........: No.FUN-5C0114 06/02/20 By kim add asri210/220/230/asrt320
# Modify.........: No.MOD-650076 06/05/17 By Claire aimt325->4
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-830065 08/03/19 By Pengu 加入asft670的說明
# Modify.........: No:MOD-B10099 11/01/13 By sabrina 加入atmt260、atmt261的說明 
# Modify.........: No:MOD-B10182 11/01/25 By sabrina atmt260單頭為入庫
# Modify.........: No:FUN-B90134 11/09/28 By rainy 新增artt256說明
# Modify.........: No:FUN-C70014 12/07/11 By wangwei 新增RUN CARD發料作業
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_command(p_prono)
   DEFINE  p_prono         LIKE tlf_file.tlf13,
           p_key           LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
           p_sts           LIKE ze_file.ze03             #No.FUN-680147 VARCHAR(14)
 
   IF p_prono IS NULL OR p_prono = ' ' THEN 
      RETURN '-', ' '
   END IF 
   CASE p_prono
#--->AIM System 
          WHEN  'aimp400 '
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-110' AND ze02 = g_lang
          WHEN  'aimp401 '
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-111' AND ze02 = g_lang
          WHEN  'aimp700 '
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-112' AND ze02 = g_lang
          WHEN  'aimp701 ' 
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-113' AND ze02 = g_lang
          WHEN  'aimp702 '
             LET p_key = '3' #調整
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-114' AND ze02 = g_lang
          WHEN  'aimp880 '
             LET p_key = '3' #調整 
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-115' AND ze02 = g_lang
          WHEN  'aimt307 '
             LET p_key = '3' #調整 
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-116' AND ze02 = g_lang
          WHEN  'aimt306 '
             LET p_key = '2' #同業借料
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-117' AND ze02 = g_lang
          WHEN  'aimt309 '
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-118' AND ze02 = g_lang
          WHEN  'aimt3101'
             LET p_key = '3' #調整
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-119' AND ze02 = g_lang
          WHEN  'aimt3102'
             LET p_key = '3' #調整
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-120' AND ze02 = g_lang
          #No.FUN-570036  --begin
          WHEN  'aimt3801'
             LET p_key = '3' #調整   #FUN-560038
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'sub-148' AND ze02 = g_lang
          WHEN  'aimt3802'
             LET p_key = '3' #調整   #FUN-560038
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'sub-149' AND ze02 = g_lang
          #No.FUN-570036  --end  
          WHEN  'aimt324 '
             LET p_key = '4' #調撥
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-121' AND ze02 = g_lang
          WHEN  'aimt720 '
             LET p_key = '4' #調撥
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-122' AND ze02 = g_lang
        #FUN-B90134 begin
          WHEN  'artt256'
             LET p_key = '4' #調撥
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-122' AND ze02 = g_lang
        #FUN-B90134 end
          WHEN  'aimt301 '
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-123' AND ze02 = g_lang
          WHEN  'aimt311 '
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-124' AND ze02 = g_lang
          WHEN  'aimt302 '
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-125' AND ze02 = g_lang
          WHEN  'aimt312 '
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-126' AND ze02 = g_lang
          WHEN  'aimt303 '
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-127' AND ze02 = g_lang
          WHEN  'aimt313 '
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-128' AND ze02 = g_lang
          WHEN  'aimt325 '
             LET p_key = '4'  #MOD-650076  '3' #調撥 
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-129' AND ze02 = g_lang
#--->APM System
          WHEN  'apmt150' 
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-130' AND ze02 = g_lang
          WHEN  'apmt230' 
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-131' AND ze02 = g_lang
          WHEN  'apmt1072'
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-132' AND ze02 = g_lang
          WHEN  'asft6001'
             LET p_key = '-' 
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-133' AND ze02 = g_lang
          WHEN  'apmt1101'
             LET p_key = '-' 
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-134' AND ze02 = g_lang
          WHEN  'apmt102'  
             LET p_key = '-' 
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-135' AND ze02 = g_lang
#--->ASF System
          WHEN  'asfi511'  
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-136' AND ze02 = g_lang
          WHEN  'asfi512'
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-137' AND ze02 = g_lang
          WHEN  'asfi513' 
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-138' AND ze02 = g_lang
          WHEN  'asfi519'                                                                 #FUN-C70014
             LET p_key = '1' #出庫                                                        #FUN-C70014
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-136' AND ze02 = g_lang #FUN-C70014
          WHEN  'asfi514'
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-139' AND ze02 = g_lang
          #FUN-5C0114...............begin
          WHEN  'asri210'
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-153' AND ze02 = g_lang
          WHEN  'asri220'
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-154' AND ze02 = g_lang
          WHEN  'asri230'
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-155' AND ze02 = g_lang
          WHEN  'asrt320'
             LET p_key = '1' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-156' AND ze02 = g_lang
          #FUN-5C0114...............end
          WHEN  'asfi526'
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-140' AND ze02 = g_lang
          WHEN  'asfi527'
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-141' AND ze02 = g_lang
          WHEN  'asfi528'
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-142' AND ze02 = g_lang
          WHEN  'asfi529'
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-143' AND ze02 = g_lang
          WHEN  'asft6201'
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-144' AND ze02 = g_lang
          WHEN  'asft6231'
             LET p_key = '2' #入庫  #BugNo.7450
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-145' AND ze02 = g_lang
          WHEN  'asft660' 
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-146' AND ze02 = g_lang
         #---------No.MOD-830065 add
          WHEN  'asft670' 
             LET p_key = '-' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-159' AND ze02 = g_lang
         #---------No.MOD-830065 end
          WHEN  'asft700' 
             LET p_key = '1' #下線入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-147' AND ze02 = g_lang
#MOD-B10099---add---start---
#--->ATM System
          WHEN  'atmt260' 
            #LET p_key = '1' #組合單                #MOD-B10182 mark
             LET p_key = '2' #組合單單頭入庫        #MOD-B10182 add 
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-056' AND ze02 = g_lang
          WHEN  'atmt261' 
             LET p_key = '1' #拆解單單頭出庫 
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-057' AND ze02 = g_lang
#MOD-B10099---add---end---
#--->AXM System
          WHEN  'aomt800'
             LET p_key = '2' #入庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-148' AND ze02 = g_lang
          WHEN  'axmt620'
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-149' AND ze02 = g_lang
          WHEN  'axmt650'
             LET p_key = '1' #出庫
             SELECT ze03 INTO p_sts FROM ze_file WHERE ze01 = 'lib-150' AND ze02 = g_lang
          OTHERWISE  LET p_key = '-' 
                     LET p_sts=' '
   END CASE
   RETURN p_key,p_sts 
END FUNCTION
