/*
================================================================================
檔案代號:gxj_file
檔案名稱:利息收入单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gxj_file
(
gxj01       varchar2(20) NOT NULL,   /*利息收入单号                           */
                                     /*利息收入單號                           */
gxj02       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
gxj03       varchar2(20),            /*定存单号                               */
                                     /*定存單號                               */
gxj031      varchar2(20),            /*申请单号                               */
                                     /*申請單號                #add 02/12/19  */
gxj04       varchar2(1),             /*计息方式                               */
                                     /*計息方式 (1.月付 2.到期整付)           */
gxj05       date,                    /*起算日期                               */
gxj06       date,                    /*止算日期                               */
gxj07       number(5),               /*利息天数                               */
                                     /*利息天數                               */
gxj08       number(20,6) DEFAULT '0' NOT NULL, /*利率*/
                                     /*利率％              #No:7354           */
gxj09       varchar2(1),             /*No Use                                 */
gxj10       number(5),               /*No Use                                 */
gxj11       number(20,6),            /*暂估原币利息                           */
                                     /*暫估原幣利息        02/11/26 alter     */
gxj12       number(20,6),            /*实付原币利息                           */
                                     /*實付原幣利息        02/11/26 alter     */
gxj13       number(20,6),            /*暂估本币利息                           */
                                     /*暫估本幣利息        02/11/26 alter     */
gxj14       number(20,6),            /*实付本币利息                           */
                                     /*實付本幣利息        02/11/26 alter     */
gxj15       number(20,6),            /*利差损失                               */
                                     /*利差損失            02/11/26 alter     */
gxj16       number(20,6),            /*汇差损失                               */
                                     /*匯差損失            02/11/26 alter     */
gxj18       number(20,6),            /*代扣原币所得税                         */
                                     /*代扣原幣所得稅 add  02/11/26 alter     */
gxj19       number(20,6),            /*代扣本币所得税                         */
                                     /*代扣本幣所得稅 add  02/11/26 alter     */
gxjud01     varchar2(255),           /*自订字段-Textedit                      */
gxjud02     varchar2(40),            /*自订字段-文字                          */
gxjud03     varchar2(40),            /*自订字段-文字                          */
gxjud04     varchar2(40),            /*自订字段-文字                          */
gxjud05     varchar2(40),            /*自订字段-文字                          */
gxjud06     varchar2(40),            /*自订字段-文字                          */
gxjud07     number(15,3),            /*自订字段-数值                          */
gxjud08     number(15,3),            /*自订字段-数值                          */
gxjud09     number(15,3),            /*自订字段-数值                          */
gxjud10     number(10),              /*自订字段-整数                          */
gxjud11     number(10),              /*自订字段-整数                          */
gxjud12     number(10),              /*自订字段-整数                          */
gxjud13     date,                    /*自订字段-日期                          */
gxjud14     date,                    /*自订字段-日期                          */
gxjud15     date,                    /*自订字段-日期                          */
gxjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index gxj_02 on gxj_file (gxj031,gxj05,gxj06);
alter table gxj_file add  constraint gxj_pk primary key  (gxj01,gxj02) enable validate;
grant select on gxj_file to tiptopgp;
grant update on gxj_file to tiptopgp;
grant delete on gxj_file to tiptopgp;
grant insert on gxj_file to tiptopgp;
grant index on gxj_file to public;
grant select on gxj_file to ods;
