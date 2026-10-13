/*
================================================================================
檔案代號:mlc_file
檔案名稱:发件单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mlc_file
(
mlc01       varchar2(12) NOT NULL,   /*邮件档名                               */
                                     /*郵件檔名(外部檔名)                     */
mlc02       varchar2(10),            /*报表编号                               */
                                     /*報表編號                               */
mlc03       varchar2(80),            /*报表名称                               */
                                     /*報表名稱                               */
mlc04       varchar2(10),            /*寄件人                                 */
mlc05       varchar2(14),            /*寄件时间                               */
                                     /*寄件時間 xx/xx/xx xx:xx                */
mlc06       varchar2(10),            /*发文编号                               */
                                     /*發文編號                               */
mlc07       varchar2(80),            /*主题                                   */
                                     /*主題                                   */
mlc08       varchar2(80),            /*主题                                   */
                                     /*主題                                   */
mlc09       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
mlc10       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
mlc11       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
mlc12       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
mlc13       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
mlc14       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
mlc15       varchar2(4),             /*查阅等级                               */
                                     /*查閱等級                               */
mlc16       number(5),               /*查阅完成天数                           */
                                     /*查閱完成天數                           */
mlc17       varchar2(1),             /*收件人                                 */
                                     /*收件人 1.轉發人員 2.自定 3.佈告        */
mlc18       varchar2(1),             /*存查                                   */
                                     /*存查  (Y/N)                            */
mlc19       varchar2(15),            /*附件档名                               */
                                     /*附件檔名                               */
mlc20       varchar2(1),             /*退件否                                 */
                                     /*退件否(Y/N)                            */
mlcsseq     number(5),               /*已签核顺序                             */
                                     /*已簽核順序                             */
mlcsmax     number(5),               /*应签核顺序                             */
                                     /*應簽核順序                             */
mlcacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
mlcuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
mlcgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
mlcmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
mlcdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
mlcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mlclegal    varchar2(10) NOT NULL,   /*所属法人                               */
mlcorig     varchar2(10),            /*资料建立部门                           */
mlcoriu     varchar2(10)             /*资料建立者                             */
);

create        index mlc_02 on mlc_file (mlc06);
alter table mlc_file add  constraint mlc_pk primary key  (mlc01) enable validate;
grant select on mlc_file to tiptopgp;
grant update on mlc_file to tiptopgp;
grant delete on mlc_file to tiptopgp;
grant insert on mlc_file to tiptopgp;
grant index on mlc_file to public;
grant select on mlc_file to ods;
