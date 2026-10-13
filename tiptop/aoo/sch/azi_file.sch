/*
================================================================================
檔案代號:azi_file
檔案名稱:币种档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table azi_file
(
azi01       varchar2(4) NOT NULL,    /*币种代码                               */
                                     /*幣別代碼                               */
azi02       varchar2(80),            /*币种说明                               */
                                     /*幣別說明                               */
azi03       number(5),               /*单价                                   */
                                     /*單價,成本小數位數(0~5)                 */
azi04       number(5),               /*金额小数位数                           */
                                     /*金額小數位數     (0~3)                 */
azi05       number(5),               /*小计,总计小数位数                      */
                                     /*小計,總計小數位數(0~3)                 */
azi07       number(5),               /*1 除汇率时所取小数位数                 */
                                     /*1 除匯率時所取小數位數(0~8)            */
azi08       varchar2(24),            /*采购汇兑损益会计科目                   */
                                     /*採購匯兌損益會計科目                   */
azi09       varchar2(24),            /*销货汇兑损益会计科目                   */
                                     /*銷貨匯兌損益會計科目                   */
aziacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
aziuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
azigrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
azimodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
azidate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
azi10       varchar2(1),             /*计算方式                               */
aziorig     varchar2(10),            /*资料建立部门                           */
azioriu     varchar2(10)             /*资料建立者                             */
);

alter table azi_file add  constraint azi_pk primary key  (azi01) enable validate;
grant select on azi_file to tiptopgp;
grant update on azi_file to tiptopgp;
grant delete on azi_file to tiptopgp;
grant insert on azi_file to tiptopgp;
grant index on azi_file to public;
grant select on azi_file to ods;
