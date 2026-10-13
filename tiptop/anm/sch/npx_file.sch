/*
================================================================================
檔案代號:npx_file
檔案名稱:票据格式设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table npx_file
(
npx01       varchar2(4) NOT NULL,    /*格式编号                               */
                                     /*格式代號                               */
npx02       varchar2(20),            /*银行编号                               */
                                     /*銀行編號                               */
npx03       number(5),               /*簿号                                   */
                                     /*簿號  modi in 99/12/29                 */
npx04       number(5),               /*页首空行                               */
                                     /*頁首空行                               */
npx05       number(5),               /*页尾空行                               */
                                     /*頁尾空行                               */
npx06       number(5),               /*页尾空行                               */
                                     /*頁尾空行                               */
npxuser     varchar2(10),            /*资料录入者                             */
npxgrup     varchar2(10),            /*资料录入者部门                         */
npxdate     date,                    /*资料录入日期                           */
npxorig     varchar2(10),            /*资料建立部门                           */
npxoriu     varchar2(10)             /*资料建立者                             */
);

alter table npx_file add  constraint npx_pk primary key  (npx01) enable validate;
grant select on npx_file to tiptopgp;
grant update on npx_file to tiptopgp;
grant delete on npx_file to tiptopgp;
grant insert on npx_file to tiptopgp;
grant index on npx_file to public;
grant select on npx_file to ods;
