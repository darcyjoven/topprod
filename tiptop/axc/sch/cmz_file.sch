/*
================================================================================
檔案代號:cmz_file
檔案名稱:LCM 参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table cmz_file
(
cmz00       varchar2(1) NOT NULL,    /*KEY VALUES(0)                          */
cmz01       date,                    /*当前基准日                             */
                                     /*目前基準日                             */
cmz02       number(9,4),             /*销售费用率                             */
                                     /*銷售費用率%                            */
cmz03       number(20,6),            /*材料A 类单价                           */
                                     /*材料A 類單價  單價>=cmz03則表示為A類   */
cmz04       number(20,6),            /*材料B 类单价                           */
                                     /*材料B 類單價  單價>=cmz04 <=cmz03為B類 */
cmz05       number(20,6),            /*材料C 类单价                           */
                                     /*材料C 類單價  單價<cmz05則表示為C類    */
cmz06       number(9,4),             /*材料A 类 呆滞比率                      */
                                     /*材料A 類 呆滯比率%                     */
cmz07       number(9,4),             /*材料B 类 呆滞比率                      */
                                     /*材料B 類 呆滯比率%                     */
cmz08       number(9,4),             /*材料C 类 呆滞比率                      */
                                     /*材料C 類 呆滯比率%                     */
cmz09       varchar2(1),             /*计算基准                               */
                                     /*計算基準 1.先進先出 2.最近異動日       */
cmz10       varchar2(1),             /*呆滞比率基准                           */
                                     /*呆滯比率基準 1.材料分類 2.區段呆滯比率 */
cmz11       varchar2(10),            /*除外仓库1                              */
                                     /*除外倉庫1  (即呆滯,不良倉)             */
cmz12       varchar2(10),            /*除外仓库2                              */
                                     /*除外倉庫2  (即呆滯,不良倉)             */
cmz13       varchar2(10),            /*除外仓库3                              */
                                     /*除外倉庫3  (即呆滯,不良倉)             */
cmz14       varchar2(10),            /*除外仓库4                              */
                                     /*除外倉庫4  (即呆滯,不良倉)             */
cmz15       varchar2(10),            /*除外仓库5                              */
                                     /*除外倉庫5  (即呆滯,不良倉)             */
cmz20       number(5),               /*区段1--起始天数                        */
                                     /*區段1--起始天數                        */
cmz21       number(5),               /*区段1--截止天数                        */
                                     /*區段1--截止天數                        */
cmz22       number(9,4),             /*区段1--呆滞比率                        */
                                     /*區段1--呆滯比率                        */
cmz30       number(5),               /*区段2--起始天数                        */
                                     /*區段2--起始天數                        */
cmz31       number(5),               /*区段2--截止天数                        */
                                     /*區段2--截止天數                        */
cmz32       number(9,4),             /*区段2--呆滞比率                        */
                                     /*區段2--呆滯比率                        */
cmz40       number(5),               /*区段3--起始天数                        */
                                     /*區段3--起始天數                        */
cmz41       number(5),               /*区段3--截止天数                        */
                                     /*區段3--截止天數                        */
cmz42       number(9,4),             /*区段3--呆滞比率                        */
                                     /*區段3--呆滯比率                        */
cmz50       number(5),               /*区段4--起始天数                        */
                                     /*區段4--起始天數                        */
cmz51       number(5),               /*区段4--截止天数                        */
                                     /*區段4--截止天數                        */
cmz52       number(9,4),             /*区段4--呆滞比率                        */
                                     /*區段4--呆滯比率                        */
cmz60       number(5),               /*区段5--起始天数                        */
                                     /*區段5--起始天數                        */
cmz61       number(5),               /*区段5--截止天数                        */
                                     /*區段5--截止天數                        */
cmz62       number(9,4),             /*区段5--呆滞比率                        */
                                     /*區段5--呆滯比率                        */
cmz70       date,                    /*异动起始日                             */
                                     /*異動起始日                             */
cmz16       varchar2(10),            /*呆滞仓                                 */
cmz80       number(10),              /*区段6--起始天数                        */
cmz81       number(10),              /*区段6--截止天数                        */
cmz82       number(9,4),             /*区段6--呆滞比率                        */
cmz83       number(10),              /*区段7--起始天数                        */
cmz84       number(10),              /*区段7--截止天数                        */
cmz85       number(9,4),             /*区段7--呆滞比率                        */
cmz86       number(10),              /*区段8--起始天数                        */
cmz87       number(10),              /*区段8--截止天数                        */
cmz88       number(9,4),             /*区段8--呆滞比率                        */
cmz89       number(10),              /*区段9--起始天数                        */
cmz90       number(10),              /*区段9--截止天数                        */
cmz91       number(9,4),             /*区段9--呆滞比率                        */
cmz17       varchar2(1),             /*净变现取成本价否                       */
cmz18       varchar2(1),             /*净变现料件分类来源                     */
cmz19       varchar2(1),             /*净变现原料评价                         */
cmz23       varchar2(10),            /*净变现逆推成品排序                     */
cmz24       varchar2(1),             /*净变现人工维护市价来源                 */
cmz25       varchar2(1),             /*逆推成品取价方法                       */
cmz26       varchar2(1),             /*净变现单价取价方式                     */
cmz27       date,                    /*净变现单价平均值取价起始日             */
cmz28       varchar2(1) DEFAULT ' ' NOT NULL /*原料逆推成品料号否*/
);

alter table cmz_file add  constraint cmz_pk primary key  (cmz00) enable validate;
grant select on cmz_file to tiptopgp;
grant update on cmz_file to tiptopgp;
grant delete on cmz_file to tiptopgp;
grant insert on cmz_file to tiptopgp;
grant index on cmz_file to public;
grant select on cmz_file to ods;
