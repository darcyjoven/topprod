/*
================================================================================
檔案代號:pib_file
檔案名稱:盘点标签号码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pib_file
(
pib01       varchar2(5) NOT NULL,    /*标签别                                 */
                                     /*標籤別                                 */
                                     /*儲存產生盤點標籤時可使用的標籤別。     */
                                     /*STK: 現有庫存的盤點標籤別              */
                                     /*WIP: 在製工單的盤點標籤別              */
                                     /*此單別為保留字                         */
pib02       varchar2(80),            /*备注说明                               */
                                     /*備註說明                               */
                                     /*儲存該標籤別之備註說明。               */
pib03       varchar2(10),            /*流水号                                 */
                                     /*流水號                                 */
                                     /*儲存目前已使用流水號                   */
pib04       varchar2(1),             /*生成方式                               */
                                     /*產生方式                               */
                                     /*儲存標籤別的產生方式。                 */
                                     /*正確值為「1/2」。                      */
                                     /*1: 系統自動產生。                      */
                                     /*2: 人為輸入。                          */
pibacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
pibuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
pibgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
pibmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
pibdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
pib05       varchar2(1),             /*底稿类别产生方式                       */
piboriu     varchar2(10),            /*资料建立者                             */
piborig     varchar2(10)             /*资料建立部门                           */
);

alter table pib_file add  constraint pib_pk primary key  (pib01) enable validate;
grant select on pib_file to tiptopgp;
grant update on pib_file to tiptopgp;
grant delete on pib_file to tiptopgp;
grant insert on pib_file to tiptopgp;
grant index on pib_file to public;
grant select on pib_file to ods;
