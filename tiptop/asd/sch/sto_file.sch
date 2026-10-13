/*
================================================================================
檔案代號:sto_file
檔案名稱:LCM计算主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sto_file
(
sto01       number(5),               /*年度                                   */
sto02       number(5),               /*月份                                   */
sto03       date,                    /*市价参考起始日期                       */
                                     /*巿價參考起始日期                       */
sto04       date,                    /*市价参考截止日期                       */
                                     /*巿價參考截止日期                       */
sto05       number(9,4)              /*推销费用率                             */
                                     /*推銷費用率%                            */
);

grant select on sto_file to tiptopgp;
grant update on sto_file to tiptopgp;
grant delete on sto_file to tiptopgp;
grant insert on sto_file to tiptopgp;
grant index on sto_file to public;
grant select on sto_file to ods;
