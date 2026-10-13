/*
================================================================================
檔案代號:sgu_file
檔案名稱:工单工艺变更档
檔案目的:工单工艺变更单身档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgu_file
(
sgu01       varchar2(40) DEFAULT ' ' NOT NULL, /*工单单号*/
sgu02       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
sgu03       varchar2(1) DEFAULT ' ' NOT NULL, /*变更方式*/
sgu04       number(5) NOT NULL,      /*工艺序号                               */
sgu05       varchar2(10),            /*原作业编号                             */
sgu06       varchar2(10),            /*原工作站                               */
sgu07       varchar2(10),            /*原机器编号                             */
sgu08       number(15,3),            /*原单位人力                             */
sgu09       number(9,4),             /*原完工比率                             */
sgu10       number(15,6),            /*原标准人工工时                         */
sgu11       number(15,6),            /*原固定人工工时                         */
sgu12       number(15,6),            /*原标准机器工时                         */
sgu13       number(15,6),            /*原固定机器工时                         */
sgu14       varchar2(1),             /*原托外否                               */
sgu15       varchar2(1),             /*原pqc否                                */
sgu16       varchar2(1),             /*原check in否                           */
sgu17       varchar2(10),            /*原check in hold留置码                  */
sgu18       varchar2(10),            /*原check out hold留置码                 */
sgu19       varchar2(4),             /*No Use                                 */
sgu20       varchar2(4),             /*原转出单位                             */
sgu21       number(20,8),            /*No Use                                 */
sgu22       date,                    /*原开工日期                             */
sgu23       date,                    /*原完工日期                             */
sgu24       varchar2(10),            /*新作业编号                             */
sgu25       varchar2(10),            /*新工作站                               */
sgu26       varchar2(10),            /*新机器编号                             */
sgu27       number(15,3),            /*新单位人力                             */
sgu28       number(9,4),             /*新完工比率                             */
sgu29       number(15,6),            /*新标准人工工时                         */
sgu30       number(15,6),            /*新固定人工工时                         */
sgu31       number(15,6),            /*新标准机器工时                         */
sgu32       number(15,6),            /*新固定机器工时                         */
sgu33       varchar2(1),             /*新托外否                               */
sgu34       varchar2(1),             /*新pqc否                                */
sgu35       varchar2(1),             /*新check in否                           */
sgu36       varchar2(10),            /*新check in hold留置码                  */
sgu37       varchar2(10),            /*新check out hold留置码                 */
sgu38       varchar2(4),             /*No Use                                 */
sgu39       varchar2(4),             /*新转出单位                             */
sgu40       number(20,8),            /*No Use                                 */
sgu41       date,                    /*新开工日期                             */
sgu42       date,                    /*新完工日期                             */
sguplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sgulegal    varchar2(10) NOT NULL,   /*所属法人                               */
sgu012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
sgu014      varchar2(80),            /*工艺段说明                             */
sgu015      varchar2(10),            /*原下工艺段号                           */
sgu016      varchar2(10),            /*新下工艺段号                           */
sgu43       number(16,8),            /*原组成用量                             */
sgu44       number(16,8),            /*原底数                                 */
sgu45       number(9,4),             /*原固定损耗量                           */
sgu46       number(15,3),            /*原变动损耗率                           */
sgu47       number(9,4),             /*原损耗批量                             */
sgu48       number(16,8),            /*新组成用量                             */
sgu49       number(16,8),            /*新底数                                 */
sgu50       number(9,4),             /*新固定损耗量                           */
sgu51       number(15,3),            /*新变动损耗率                           */
sgu52       number(9,4),             /*新损耗批量                             */
sgu53       varchar2(10),            /*原委外厂商                             */
sgu54       varchar2(10)             /*新委外厂商                             */
);

alter table sgu_file add  constraint sgu_pk primary key  (sgu01,sgu02,sgu04,sgu012) enable validate;
grant select on sgu_file to tiptopgp;
grant update on sgu_file to tiptopgp;
grant delete on sgu_file to tiptopgp;
grant insert on sgu_file to tiptopgp;
grant index on sgu_file to public;
grant select on sgu_file to ods;
