/*
================================================================================
檔案代號:smx_file
檔案名稱:异动记录报表内容单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table smx_file
(
smx01       varchar2(8) NOT NULL,    /*报表编号                               */
                                     /*報表代號                               */
smx02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
smx03       number(5),               /*排列行序                               */
                                     /*允許值1/2/3                            */
smx04       number(5),               /*排列栏序                               */
                                     /*排列欄序                               */
                                     /*行序加上欄序不可重複                   */
smx05       varchar2(10),            /*字段来源                               */
                                     /*欄位來源                               */
smx06       number(15,3),            /*字段长度                               */
                                     /*欄位長度                               */
smx07       number(5),               /*字段性质                               */
                                     /*欄位性質                               */
                                     /*0.char 在報表中左靠                    */
                                     /*>0.numeric 在報表中右靠                */
smxdmy1     varchar2(1),             /*No Use                                 */
smxdmy2     varchar2(1)              /*No Use                                 */
);

alter table smx_file add  constraint smx_pk primary key  (smx01,smx02) enable validate;
grant select on smx_file to tiptopgp;
grant update on smx_file to tiptopgp;
grant delete on smx_file to tiptopgp;
grant insert on smx_file to tiptopgp;
grant index on smx_file to public;
grant select on smx_file to ods;
