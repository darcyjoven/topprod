/*
================================================================================
檔案代號:asd_file
檔案名稱:关联企业异动维护作业（单身）
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table asd_file
(
asd00       date DEFAULT sysdate NOT NULL, /*异动日期*/
asd01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asd02       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司代号*/
asd03       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
asd04       number(5) DEFAULT '0' NOT NULL, /*项次*/
asd04a      varchar2(10),            /*异动后下层公司编号                     */
asd04b      varchar2(10),            /*异动前下层公司编号                     */
asd051a     varchar2(1),             /*NO USE                                 */
asd051b     varchar2(1),             /*NO USE                                 */
asd05a      varchar2(5),             /*异动后下层帐套                         */
asd05b      varchar2(5),             /*异动前下层帐套                         */
asd06a      varchar2(1) DEFAULT 'N' NOT NULL, /*异动后纳入合并否*/
asd06b      varchar2(1) DEFAULT 'N' NOT NULL, /*异动前纳入合并否*/
asd07a      number(9,4) DEFAULT '0' NOT NULL, /*异动后持股比率*/
asd07b      number(9,4) DEFAULT '0' NOT NULL, /*异动前持股比率*/
asd08a      date,                    /*异动后异动日期                         */
asd08b      date,                    /*异动前异动日期                         */
asd09a      varchar2(1),             /*NO USE                                 */
asd09b      varchar2(1),             /*NO USE                                 */
asd10       varchar2(1),             /*NO USE                                 */
asd11a      number(10) DEFAULT '0' NOT NULL, /*异动后投资股数*/
asd11b      number(10) DEFAULT '0' NOT NULL, /*异动前投资股数*/
asd12a      number(20,6) DEFAULT '0' NOT NULL, /*异动后股本*/
asd12b      number(20,6) DEFAULT '0' NOT NULL, /*异动前股本*/
asd13b      varchar2(1) DEFAULT 'N' NOT NULL, /*股本否*/
asd14b      varchar2(24)             /*会计科目                               */
);

alter table asd_file add  constraint asd_pk primary key  (asd00,asd01,asd02,asd03,asd04) enable validate;
grant select on asd_file to tiptopgp;
grant update on asd_file to tiptopgp;
grant delete on asd_file to tiptopgp;
grant insert on asd_file to tiptopgp;
grant index on asd_file to public;
grant select on asd_file to ods;
