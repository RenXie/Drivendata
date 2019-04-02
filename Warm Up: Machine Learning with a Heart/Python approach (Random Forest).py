import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns #for plotting
from sklearn.ensemble import RandomForestClassifier #for the model
from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import export_graphviz #plot tree
from sklearn.metrics import roc_curve, auc #for model evaluation
from sklearn.metrics import classification_report #for model evaluation
from sklearn.metrics import confusion_matrix #for model evaluation
from sklearn.model_selection import train_test_split #for data splitting
import eli5 #for purmutation importance
from eli5.sklearn import PermutationImportance
import shap #for SHAP values
from pdpbox import pdp, info_plots #for partial plots
np.random.seed(123) #ensure reproducibility


dt = pd.read_csv("train_values.csv")
dt.head(10)
dtr = pd.read_csv("train_labels.csv")
dt = pd.concat([dt, dtr.loc[:,'heart_disease_present']], axis=1, sort=False)
del dt['patient_id']

dt['thal'][dt['thal'] == 'normal'] = 1
dt['thal'][dt['thal'] == 'fixed_defect'] = 2
dt['thal'][dt['thal'] == 'reversible_defect'] = 3

dt.dtypes
dt['sex'] = dt['sex'].astype('object')
dt['chest_pain_type'] = dt['chest_pain_type'].astype('object')
dt['fasting_blood_sugar_gt_120_mg_per_dl'] = dt['fasting_blood_sugar_gt_120_mg_per_dl'].astype('object')
dt['resting_ekg_results'] = dt['resting_ekg_results'].astype('object')
dt['exercise_induced_angina'] = dt['exercise_induced_angina'].astype('object')
dt['slope_of_peak_exercise_st_segment'] = dt['slope_of_peak_exercise_st_segment'].astype('object')

#Random Forest
X_train, X_test, y_train, y_test = train_test_split(dt.drop('heart_disease_present', 1), dt['heart_disease_present'], test_size = .2, random_state=10)
model = RandomForestClassifier(max_depth=5)
model.fit(X_train, y_train)
RandomForestClassifier(bootstrap=True, class_weight=None, criterion='gini',
            max_depth=5, max_features='auto', max_leaf_nodes=None,
            min_impurity_decrease=0.0, min_impurity_split=None,
            min_samples_leaf=1, min_samples_split=2,
            min_weight_fraction_leaf=0.0, n_estimators=10, n_jobs=None,
            oob_score=False, random_state=None, verbose=0,
            warm_start=False)

#Result evaluation
y_predict = model.predict(X_test)
y_pred_quant = model.predict_proba(X_test)[:, 1]
y_pred_bin = model.predict(X_test)

confusion_matrix = confusion_matrix(y_test, y_pred_bin)
confusion_matrix

total=sum(sum(confusion_matrix))

sensitivity = confusion_matrix[0,0]/(confusion_matrix[0,0]+confusion_matrix[1,0])
print('Sensitivity : ', sensitivity )

specificity = confusion_matrix[1,1]/(confusion_matrix[1,1]+confusion_matrix[0,1])
print('Specificity : ', specificity)


#ROC
fpr, tpr, thresholds = roc_curve(y_test, y_pred_quant)

fig, ax = plt.subplots()
ax.plot(fpr, tpr)
ax.plot([0, 1], [0, 1], transform=ax.transAxes, ls="--", c=".3")
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.0])
plt.rcParams['font.size'] = 12
plt.title('ROC curve for diabetes classifier')
plt.xlabel('False Positive Rate (1 - Specificity)')
plt.ylabel('True Positive Rate (Sensitivity)')
plt.grid(True)

#AUC
auc(fpr, tpr)

#Submission
dtt = pd.read_csv('test_values.csv')
dtt['thal'][dtt['thal'] == 'normal'] = 1
dtt['thal'][dtt['thal'] == 'fixed_defect'] = 2
dtt['thal'][dtt['thal'] == 'reversible_defect'] = 3
del dtt['patient_id']

dtt.dtypes
dtt['sex'] = dtt['sex'].astype('object')
dtt['chest_pain_type'] = dtt['chest_pain_type'].astype('object')
dtt['fasting_blood_sugar_gt_120_mg_per_dl'] = dtt['fasting_blood_sugar_gt_120_mg_per_dl'].astype('object')
dtt['resting_ekg_results'] = dtt['resting_ekg_results'].astype('object')
dtt['exercise_induced_angina'] = dtt['exercise_induced_angina'].astype('object')
dtt['slope_of_peak_exercise_st_segment'] = dtt['slope_of_peak_exercise_st_segment'].astype('object')

test_pred_quant = model.predict_proba(dtt)[:, 1]
submission_p = pd.read_csv('submission_format.csv')
submission_p.loc[:,'heart_disease_present'] = test_pred_quant

export_csv = submission_p.to_csv ('submission.csv', index = None, header=True) 
