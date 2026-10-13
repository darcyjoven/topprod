/*
================================================================================
檔案代號:fby_file
檔案名稱:资产主类别异动单单身
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fby_file
(
fby01       varchar2(16) DEFAULT ' ' NOT NULL, /*异动单号*/
fby02       number(5) DEFAULT '0' NOT NULL, /*项次*/
fby03       varchar2(10),            /*财产编号                               */
fby031      varchar2(4),             /*附号                                   */
fby04       varchar2(10),            /*异动前资产类别                         */
fby05       varchar2(24),            /*异动前资产科目                         */
fby052      varchar2(24),            /*异动前资产科目(财签二)                 */
fby06       varchar2(24),            /*异动前累折科目                         */
fby062      varchar2(24),            /*异动前累折科目(财签二)                 */
fby07       varchar2(24),            /*异动前折旧科目                         */
fby072      varchar2(24),            /*异动前折旧科目(财签二)                 */
fby08       varchar2(10),            /*异动后资产类别                         */
fby09       varchar2(24),            /*异动后资产科目                         */
fby092      varchar2(24),            /*异动后资产科目(财签二)                 */
fby10       varchar2(24),            /*异动后累折科目                         */
fby102      varchar2(24),            /*异动后累折科目(财签二)                 */
fby11       varchar2(24),            /*异动后折旧科目                         */
fby112      varchar2(24),            /*异动后折旧科目(财签二)                 */
fbylegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table fby_file add  constraint fby_pk primary key  (fby01,fby02) enable validate;
grant select on fby_file to tiptopgp;
grant update on fby_file to tiptopgp;
grant delete on fby_file to tiptopgp;
grant insert on fby_file to tiptopgp;
grant index on fby_file to public;
grant select on fby_file to ods;
